<template>
  <!-- uni-app 要求 template 内必须有且仅有一个根节点 -->
  <view class="page-container">
    <!-- 紧急求助按钮 -->
    <view class="emergency-wrap">
      <view class="button emergency emergency-btn" @click="handleEmergency">
        <uni-icons type="phone-filled" size="48" color="#fff"></uni-icons>
        <text class="button-text">紧急求助</text>
      </view>
    </view>

    <!-- 第二排按钮 -->
    <view class="button-row">
      <view class="button health health-btn" @click="handleHealth">
        <uni-icons type="heart" size="48" color="#fff"></uni-icons>
        <text class="button-text">健康记录</text>
      </view>
      <view class="button tcm tcm-btn" @click="handleTCM">
        <uni-icons type="circle" size="48" color="#fff"></uni-icons>
        <text class="button-text">智能中医</text>
      </view>
    </view>

    <!-- 第三排按钮 -->
    <view class="button-row">
      <view class="button chat chat-btn" @click="handleChat">
        <uni-icons type="chat" size="48" color="#fff"></uni-icons>
        <text class="button-text">聊天陪伴</text>
      </view>
      <view class="button teaching teaching-btn" @click="handleTeaching">
        <uni-icons type="bookmark" size="48" color="#fff"></uni-icons>
        <text class="button-text">智能教学</text>
      </view>
    </view>
  </view>
</template>

<script setup>
// 按钮点击事件
const handleEmergency = () => {
  uni.showToast({
    title: '紧急求助已触发',
    icon: 'none'
  });
};

const handleHealth = () => {
  uni.showToast({
    title: '进入健康记录页面',
    icon: 'none'
  });
};

const handleTCM = () => {
  uni.showToast({
    title: '进入智能中医页面',
    icon: 'none'
  });
};

const handleChat = () => {
  uni.showToast({
    title: '进入聊天陪伴页面',
    icon: 'none'
  });
};

const handleTeaching = () => {
  uni.showToast({
    title: '进入智能教学页面',
    icon: 'none'
  });
};
</script>

<style scoped>
/* 页面基础样式 */
page {
  background-color: #f5f5f5;
  padding: 20rpx;
  min-height: 100vh;
}

/* 根容器 */
.page-container {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  align-items: center;
}

/* 紧急求助按钮容器 */
.emergency-wrap {
  width: 100%;
  max-width: calc(100% - 0rpx);
}

/* 按钮行布局 */
.button-row {
  display: flex;
  gap: 20rpx;
  width: 100%;
}

/* 通用按钮样式（保留基础样式，宽高由独立类名覆盖） */
.button {
  border-radius: 12rpx;
  color: #fff;
  font-size: 28rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12rpx;
  padding: 20rpx;
  box-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.15);
  transition: transform 0.2s ease;
  cursor: pointer;
  /* 取消通用宽度，改为每个按钮独立控制 */
  width: auto;
  /* 取消通用高度，改为每个按钮独立控制 */
  height: auto;
}

/* 按钮点击效果 */
.button:active {
  transform: translateY(-3rpx);
}

/* 各按钮配色 */
.emergency { background-color: #ed2633; }
.health { background-color: #34b739; }
.tcm { background-color: #ff9800; }
.chat { background-color: #1677ff; }
.teaching { background-color: #9254de; }

/* -------------------------- 核心：自定义每个按钮的宽高 -------------------------- */
/* 紧急求助按钮 */
.emergency-btn {
  width: 640rpx;    
  height: 120rpx;   
  /* 居中显示 */
  margin: -10 auto;
}

/* 健康记录按钮 */
.health-btn {
  width: 290rpx;    
  height: 200rpx;   
}

/* 智能中医按钮 */
.tcm-btn {
  width: 290rpx;  
  height: 200rpx;
}

/* 聊天陪伴按钮 */
.chat-btn {
  width: 290rpx;  
  height: 200rpx; 
}

/* 智能教学按钮 */
.teaching-btn {
  width: 290rpx;
  height: 200rpx; 
}

/* 按钮文字样式（可选：如需调整文字大小也可独立控制） */
.button-text {
  font-size: 28rpx;
}
</style>