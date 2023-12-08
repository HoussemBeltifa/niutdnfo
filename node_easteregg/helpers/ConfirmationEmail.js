let nodemailer=require('nodemailer');
const transport=nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 587,
    secure: false, // upgrade later with STARTTLS
    auth: {
      user: "abderraoufdenden2022@gmail.com",
      pass: "rkzanptbjpivvntp",
    },
  });
  const year=new Date().getFullYear();
  module.exports.sendconfirmationemail=(email,token)=>{
   transport.sendMail({
        from: 'abderraoufdenden2022@gmail.com',
        to: email,
        subject: 'confirmemail',
        html: `<html><body>

        <a href='http://localhost:5000/confirm-mail/${token}'>Click here to confirm your account</a>


      </body>
        </html>`
    }, (err, info) => {
        if(err){
       console.log(err);
        }
        

    });


  }