const { App } = require("@slack/bolt");
require("dotenv").config();

const app = new App({
  token: process.env.SLACK_BOT_TOKEN,
  signingSecret: process.env.SLACK_SIGNING_SECRET,
  //socketMode: true,
  //appToken: process.env.SLACK_APP_TOKEN,
  port: process.env.PORT,
});

// hello 라는 메세지가 오는 것을 감지
app.message("hello", async ({ message, say }) => {
  // say() 는 block 이라고 하는 슬랙 메세지 형태의 일종을 보내는 함수 
  // blocks 를 설정 보냄
  await say({
    blocks: [
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: `Hey there <@${message.user}>!`,
        },
        accessory: {
          type: "button",
          text: {
            type: "plain_text",
            text: "Click Me",
          },
          action_id: "button_click",
        },
      },
    ],
    text: `Hey there <@${message.user}>!`,
  });
});

app.action("button_click", async ({ body, ack, say }) => {
  // Acknowledge the action
  await ack();
  await say(`<@${body.user.id}> clicked the button`);
});

(async () => {
  // Start your app
  await app.start();

  console.log("⚡️ Bolt app is running!");
})();
