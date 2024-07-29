// 
// 애플리케이션의 진입점을 정의
// 서버를 설정하고, 기본 라우트와 사용자 라우트를 설정하고, 서버를 시작
//

const express = require('express');

const userRouter = require('./userRouter');

const app = express();

const PORT = 4000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.use('/users', userRouter); // 사용자 라우트를 설정

app.listen(PORT, () => {  
  console.log(`Server is running on port ${PORT}`);
});
