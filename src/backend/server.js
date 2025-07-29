const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config({path: './.env'});

const app = require('./app');

const DB = process.env.MONGODB_URL.replace(
    '<db_password>',
    encodeURIComponent(process.env.MONGODB_PASSWORD),
);

mongoose.connect(DB).then(()=>{
    console.log('✅ DB Connected Successfully');
}).catch((err)=>{
    console.log('Error Connecting to MongoDB ❌', err);
})

const port = process.env.PORT || 3000;

app.listen(port, ()=>{
    console.log(`✅ App is running on port ${port}`);
})