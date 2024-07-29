//
// MySQL 데이터베이스와의 연결을 설정하는 파일
//

const mysql = require('mysql2');
require('dotenv').config({path: '../.env'});

const dbUser = process.env.MYSQL_USER
const dbPassword = process.env.MYSQL_PASSWORD
const dbName = process.env.MYSQL_DATABASE

// MySQL 연결 풀을 생성
// 여러 개의 연결을 미리 열어 두고 요청이 있을 때마다 재사용
const pool = mysql.createPool({ 
    host: 'db', // MySQL 호스트명 (Docker Compose 설정에서 'db' 서비스)
    user: dbUser,
    password: dbPassword,
    database: dbName,
    waitForConnections: true, // 연결이 가득 차면 대기할지 여부
    connectionLimit: 10, // 최대 연결 수
    queueLimit: 0 // 대기열의 최대 크기 (0은 무제한)
})


module.exports = pool.promise(); // Promise 기반의 MySQL 연결 풀을 반환