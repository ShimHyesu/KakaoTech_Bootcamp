//
// 데이터베이스와의 연결을 설정하는 파일
//

const mariadb = require('mariadb');
require('dotenv').config({path: '../.env'});

const db = process.env.DB_DATABASE
const dbUser = process.env.DB_USER
const dbPassword = process.env.DB_PASSWORD

// 연결 풀을 생성
// 여러 개의 연결을 미리 열어 두고 요청이 있을 때마다 재사용
const pool = mariadb.createPool({ 
    host: 'db', // Docker Compose 설정에서 'db' 서비스
    user: dbUser,
    password: dbPassword,
    database: db,
    connectionLimit: 10, // 최대 연결 수
})

async function fetchConn(){
    let conn = await pool.getConnection();
    return conn;
}


module.exports = fetchConn;