const express = require("express");
const mongoose = require("mongoose");
const app = express();
const User = require("./userinfo");
const ProfileProduct = require("./profileuser");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
var cors = require('cors')

const multer = require('multer');
const profileuser = require("./profileuser");

const http=require('http');

const server = http.createServer(app);
const so=require('socket.io');
const io = so(server);
const userphone=require('./phoneuser');
const emailsending=require('./helpers/ConfirmationEmail');
const client = require('twilio')(
    'AC3640dffa5378b01db82b66308a467c15',
    '5a933c6c5986d5d7a8b87b916dda5b1c'
  );
  

app.use(cors({origin: '*',// For legacy browser support
methods: "GET,PUT,POST,DELETE"}));
app.use(express.json());
app.use(express.urlencoded({
    extended: true
}));
io.on('connection', (socket) => { console.log('joinconnection');
socket.on('joinchat',(chate)=>{
    console.log('joinedchat');
    socket.join(chate);
    socket.on('sendmessage',(data)=>{
    socket.to(chate).emit('receivemessage',data);
    });
})

});




const dotenv = require('dotenv');
const { Like } = require("./LikeSchema");
const { Match } = require("./MatchSchema");
const { Discussion } = require("./DiscussionModel");
const { Messaged } = require("./MessageModelll");
dotenv.config();


const productData = [];
const profileproductData = [];

// Connect to mongoose
mongoose.set('strictQuery', true);
mongoose.connect("mongodb+srv://baabadevs:admin123@mernapp.gendjkv.mongodb.net/easteregg", {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => {
    console.log("Connected to mongoose");

    app.use('/uploads', express.static('uploads'));

  // Define the Message schema
  const messageSchema = new mongoose.Schema({
    senderId: String,
    receiverId: String,
    messageText: String,
    timestamp: { type: Date, default: Date.now },
});


const Message = mongoose.model("Message", messageSchema);

const verifyToken = async(req, res, next) =>{
    const token = req.headers['authorization'];
   
    if (!token) return res.sendStatus(401);
  

    jwt.verify(token, process.env.tokensecret, async(err, user) => {

     
        
        if (err) return res.sendStatus(403);
   
        if(!user){
            return res.sendStatus(403);
        }
        const usera=await User.findById(new mongoose.Types.ObjectId(user.userId));
        console.log(usera);
        if(!usera){
            return res.sendStatus(403);
        }
        if(!usera.is_activated){
            return res.sendStatus(403);
        }
    
        req.user=usera;
        next();

        
    });
};
// Add a new message
app.post("/send_message/:id",verifyToken, async (req, res) => {
    try {
        console.log('here');

        const newMessage = new Messaged({
           discussion:new mongoose.Types.ObjectId(req.params.id),
           messageText:req.body.messageText,
           senderId:new mongoose.Types.ObjectId(req.user._id)
        });

        console.log("Creating new message:", newMessage);

        const savedMessage = await newMessage.save();
        console.log("Saved message:", savedMessage);

        res.status(200).json(savedMessage);
    } catch (error) {
        console.error("Error saving messageText:", error);
        res.status(400).json({ error: error.message });
    }
});




// Get messages between two users
app.get("/get_messages/:senderId/:receiverId", async (req, res) => {
    try {
        const senderId = req.params.senderId;
        const receiverId = req.params.receiverId;

        const messages = await Message.find({
            $or: [
                { senderId, receiverId },
                { senderId: receiverId, receiverId: senderId },
            ],
        }).sort({ timestamp: 1 });

        res.status(200).json(messages);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

function makeid(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    let counter = 0;
    while (counter < length) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
      counter += 1;
    }
    return result;
}
function makecode(length) {
    let result = '';
    const characters = '0123456789';
    const charactersLength = characters.length;
    let counter = 0;
    while (counter < length) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
      counter += 1;
    }
    return result;
}

    // post api
app.post("/add_user", async (req,res)=>{

    console.log("Result", req.body);

   
    const user=await User.findOne({email:req.body.email})
    if(user){
       return res.status(400).json({
            'status':'email already exists'
        });
    }


    try {
       const token=makeid(12);
     
       let data = User({...req.body,token:token,source:'local'});
       let dataToStore = await data.save();
       emailsending.sendconfirmationemail(req.body.email,token);
       return res.status(200).json(dataToStore);

    } catch (error) {
        return res.status(400).json({
            'status': error.message
        })
    }

})
app.get("/confirm-mail/:token", async (req,res)=>{

    console.log("Result", req.body);

   
    const user=await User.findOneAndUpdate({token:req.params.token},{token:null,is_activated:true});
    if(!user){
        return res.status(400).send('token expired');
    }
    return res.status(200).send('account activated');
   

});
app.post("/regphone", async (req,res)=>{
   
    let user = await User.findOneAndUpdate(
        {
             email:req.body.phone,source:'phone' 
        },
        { 
          $set: { email:req.body.phone,source:'phone'}
        },
        { upsert: true ,new:true});

   const code=makecode(6);
   await userphone.deleteMany({user:new mongoose.Types.ObjectId(user._id)});
        let phoneuser=await userphone.create({user:new mongoose.Types.ObjectId(user._id),code:code});
        client.messages
        .create({ from:'+122 93 982 743', to:req.body.phone, body :code})
        .then((message) => {
            
    
          return res.send('message sent to your phone number');
        })
        .catch((error) => {
          console.error(error);
          return res.send('error');
        });
   
   

});
app.post("/regphone/:code", async (req,res)=>{

    let userphonz=await userphone.findOne({code:req.params.code});
    if(!userphonz){
        return res.send('invalid code');
    }
   await userphone.deleteOne({code:req.params.code});
    const user = await User.findById(new mongoose.Types.ObjectId(userphonz.user));
        // Generate a JWT token
        const token = jwt.sign({ userId: user._id }, process.env.tokensecret, {
            expiresIn: "1h", // Adjust token expiration as needed
        });

        // await user.save();
        const profile = await profileuser.findOne({user: new mongoose.Types.ObjectId(user._id)});
        res.status(200).json({ token : token, profile: !!profile});

   
   

});



// ...
// Login route
app.post("/login", async (req, res) => {
    console.log('dd00');
    const { email, password } = req.body;

    try {
        // Find user by email
        const user = await User.findOne({ email: email });

        if (!user) {
            return res.status(401).json({ message: "Invalid credentials" });
        }

        // Compare hashed password
        const passwordMatch = (password == user.password);

        if (!passwordMatch) {
            return res.status(401).json({ message: "Invalid credentials" });
        }

        // Generate a JWT token
        const token = jwt.sign({ userId: user._id }, process.env.tokensecret, {
            expiresIn: '2h' //"1h", // Adjust token expiration as needed   '8m' '7d'
        });

        // await user.save();
        const profile = await profileuser.findOne({user: user._id});
        res.status(200).json({ token : token, profile: !!profile});
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});





  
// Check if the user is logged in
app.post("/check-login",async(req, res) => {
    
   
   console.log('success is logged in');
    res.status(200).json({profile:'ok'});
});

  // ...
  

app.post("/add_profileuser", upload.any(), verifyToken ,async (req,res)=>{
    console.log('here');

  
    let dataprofileuser = req.body;
    let image=[];
   req.files.forEach(file => {
    image.push(file.filename);
   });
   dataprofileuser.image = image;
   console.log(req.user._id);

    dataprofileuser.user = new mongoose.Types.ObjectId(req.user._id);
    let data = ProfileProduct(dataprofileuser);

    try {
       let dataToStore = await data.save();
       await User.findByIdAndUpdate(new  mongoose.Types.ObjectId(req.user._id), {is_completed: true
    }); 
       res.status(200).json(dataToStore);

    } catch (error) {
        res.status(400).json({
            'status': error.message
        })
    }

})





/*
// Get profile data for a user by ID
app.get("/get_profileuser/:id", verifyToken, async (req, res) => {
    try {
        const userId = req.params.id;

        // Check if the requested user ID matches the ID from the token
        if (userId !== req.user.userId) {
            return res.status(403).json({ message: "Access denied" });
        }

        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        // Extract and return the user's profile data
        const profileData = {
            fname: user.fname,
            lname: user.lname,
            age: user.age,
            phone: user.phone,
            // Add more fields as needed
        };

        res.status(200).json(profileData);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
*/



//get api 
app.get("/get_user/",async (req,res)=>{
    try {
        let data = await User.find();
        res.status(200).json(data);
    } catch (error) {
        res.status(500).json(error.message);
    }

})


//get api 
app.get("/get_profileuser/",verifyToken,async (req,res)=>{
    let likes=await Like.find({liker:new mongoose.Types.ObjectId(req.user._id)});
    likes=likes.map(x=>new mongoose.Types.ObjectId(x.liked));
    likes.push(new mongoose.Types.ObjectId(req.user._id));
    try {
        let data = await ProfileProduct.find({user: { $nin:likes}}).limit(100);
        console.log(data);
        res.status(200).json(data);
    } catch (error) {
        console.log(error);
        res.status(500).json(error.message);
    }

})
app.get("/messagesget/:id",verifyToken,async(req,res)=>{
    console.log(req.query.index);
    var messages=await Messaged.find({discussion:new mongoose.Types.ObjectId(req.params.id)})
    .skip(parseInt(req.query.index)).sort({createdAt:-1}).limit(15);
    console.log(messages);
    res.json(messages);

});
app.get("/discussion/:id",verifyToken,async (req,res)=>{
    let discussion = await Discussion.findOneAndUpdate(
        {
          users: { $all: [{$elemMatch:{$eq:new mongoose.Types.ObjectId(req.user._id)}}, {$elemMatch:{$eq:new mongoose.Types.ObjectId(req.params.id)}}] }
        },
        { 
          $set: { users: [new mongoose.Types.ObjectId(req.user._id), new mongoose.Types.ObjectId(req.params.id)] }
        },
        { upsert: true ,new:true}
      ).populate({path:'messages',model:Messaged,options: {limit:15, sort: { createdAt: -1}}});
      var messageslength=await Messaged.count();
    const profile=await ProfileProduct.findOne({user:new mongoose.Types.ObjectId(req.params.id)});
     res.json({messages:discussion.messages,profile:profile,id:discussion._id,iduser:req.user._id,lenmsg:messageslength});
})
app.get("/getchatlist/",verifyToken,async (req,res)=>{
    let matches=await Match.find({users:{$in:[new mongoose.Types.ObjectId(req.user._id)]}});
    let users=[];
    console.log(matches);
    matches.forEach(match => {

        match.users.forEach(user => {
            if(user.toString()!=req.user._id.toString()){
                users.push(user);
            }
        });
        
    });
    console.log(users);
    let profiles=await ProfileProduct.find({user:{$in:users}});
    return res.json(profiles);

})
app.post("/like/:id",verifyToken,async (req,res)=>{


    let data = await Like.findOne({liker:new mongoose.Types.ObjectId(req.user._id),liked:new mongoose.Types.ObjectId(req.params.id)});
    if(data){
        console.log('exist');
        return res.status(400).json({message:'exist'});
    }
    

    let dataz = await Like.findOne({liked:new mongoose.Types.ObjectId(req.user._id),liker:new mongoose.Types.ObjectId(req.params.id)});
   
        await Like.create({liker:new mongoose.Types.ObjectId(req.user._id),liked:new mongoose.Types.ObjectId(req.params.id)}).then(async(a)=>{
            console.log(a);
            if(dataz){
                await Match.create({users:[new mongoose.Types.ObjectId(req.user._id),new mongoose.Types.ObjectId(req.params.id)]});
            }
            return res.status(201).json(a);
        }).catch((ez)=>{
            return res.status(500).json({message:ez});

        })
      
    

})
app.post("/dislike/:id",verifyToken,async (req,res)=>{

    await Like.findOneAndDelete({liker:new mongoose.Types.ObjectId(req.user._id),liked:new mongoose.Types.ObjectId(req.params.id)})
    .then(async(a)=>{
        await Match.findOneAndDelete({users: { $all: [{$elemMatch:{$eq:new mongoose.Types.ObjectId(req.user._id)}}, {$elemMatch:{$eq:new mongoose.Types.ObjectId(req.params.id)}}]}});
            return res.status(200).send('deleted');
        }).catch((ez)=>{
            return res.status(400).json({message:ez});

        })
      
    

})
app.get("/likes",verifyToken,async (req,res)=>{

    await Like.find({liker:new mongoose.Types.ObjectId(req.user._id)}).
    populate({path:'liked',model:User,select:['_id'],populate:{path:'profile',model:profileuser}})
    .then((a)=>{
        return res.json(a);
    })
    .catch((ez)=>{
            return res.status(400).json({message:ez});

        })
      
})

///////////////////
// lyoum zedthm 16/09/2023

app.get("/get_profileusertoupdate/",verifyToken,async (req,res)=>{
    
    let profiles=await ProfileProduct.findOne({user:new mongoose.Types.ObjectId(req.user._id)});
    return res.json(profiles);

})

app.put("/update_profileuser", upload.any(), verifyToken ,async (req, res) => {
    let id = req.user._id;

    console.log(req.user._id);
    
    let updatedData = req.body; // Remove the extra comment and fix the assignment
    let options = { new: true };
    let image=[];
    console.log(req.files);
    let index =0;
    filessData = await profileuser.findOne({user: new mongoose.Types.ObjectId(req.user._id)});
    console.log(req.body['image0']);
    filessData.image.forEach((imagea,indexa) => {
        if (req.body['image'+indexa]== 'true')  {
            image.push(req.files[index].filename);
            index=index+1;
        } else{
            image.push(imagea);
        }
        
    });
let imagetttttttt =req.files.splice(index);
imagetttttttt.forEach(imagea => {
    image.push(imagea.filename);
});

    updatedData.image = image;

    console.log(req.body);
    console.log("id:");
    console.log(id);

    try {
        const data = await profileuser.findOneAndUpdate({user:new mongoose.Types.ObjectId(id)}, updatedData, options);
        return res.send(data);
    } catch (error) {
        return res.send(error.message);
    }
});

///////
//update api put
app.put("/update/:id", async (req,res)=> {

    let id = req.params.id;
    let updatedData = // JSON.parse(
        req.body;
    let options = {new : true};
    console.log(req.body);
    console.log("id:");
    console.log(id);

    try {
        const data = await User.findByIdAndUpdate(id, updatedData, options);

       return res.send(data);
    } catch (error) {
       return res.send(error.message);
        
    }

})


//delete Product
app.delete("/delete/:id", async (req,res)=> {

    let id = req.params.id;
    try {
        
        const data = await User.findByIdAndDelete(id);
        res.json({
            'status': "Deleted the user ${data.pname} from database"
        })
    } catch (error) {
        
    }

})

})
.catch(error => {
    console.error("Error connecting to mongoose:", error);
});


// upload images
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, 'uploads'); // Define the upload directory
    },
    filename: (req, file, cb) => {
      cb(null, Date.now() + '-' + file.originalname);
    },
  });
  
  const upload = multer({ storage: storage });
  
  app.post('/upload', upload.single('image'), (req, res) => {
    console.log('Received an image upload request'); // Add this line
    console.log('Image received:', req.file.filename);
    res.status(200).send('Image uploaded successfully');
  });


// start server
server.listen(2000, ()=> {
    console.log("Connected to server at 2000");
})