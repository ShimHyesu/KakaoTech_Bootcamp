//
// Express.js 라우터 모듈
// 데이터베이스와 상호작용하여 사용자 데이터를 조회하는 기능을 제공
//

const express = require('express');
const fetchConn = require('./connection');

const userRouter = express.Router();

userRouter.get('/', (req, res) => {
    res.send('User Router');
})

userRouter.get('/getUsers', async (req, res) => {
    let conn;
    try {
        conn = await fetchConn();

        const [results] = await conn.query('SELECT * FROM users');
        res.json(results);
    } catch (err) {
        console.error('Error fetching users:', err);
        res.status(500).send('Error fetching users');
    }finally {
        if(conn) conn.end();
    }
});

module.exports = userRouter;