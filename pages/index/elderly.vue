<template>
  <view class="elderly-page">
    <!-- 顶部状态栏 -->
    <view class="status-bar">
      <view class="status-item connected">
        <view class="dot"></view>
        <text>已连接</text>
      </view>
      <text class="time">{{ currentTime }}</text>
    </view>

    <!-- 今日健康卡片（新增） -->
    <view class="health-card">
      <text class="health-title"><text class="fas fa-heartbeat"></text> 今日健康</text>
      <view class="health-grid">
        <view class="health-item">
          <text class="label">心率</text>
          <text class="value">{{ heartRate }}</text>
          <text class="unit">bpm</text>
        </view>
        <view class="health-item">
          <text class="label">体温</text>
          <text class="value">{{ temperature }}</text>
          <text class="unit">°C</text>
        </view>
        <view class="health-item">
          <text class="label">体质</text>
          <text class="value">{{ constitution }}</text>
          <text class="unit"></text>
        </view>
      </view>
    </view>

    <!-- 功能按钮区 -->
    <view class="function-buttons">
      <view 
        class="function-btn emergency"
        @click="showToast('紧急呼叫已发起，正在联系家属和120...')"
      >
        <view class="icon-wrapper">
          <text class="fas fa-phone"></text>
        </view>
        <view class="info">
          <text class="title">紧急呼叫</text>
          <text class="desc">呼叫子女 / 120</text>
        </view>
        <text class="fas fa-chevron-right"></text>
      </view>

      <!-- 看名医按钮：点击跳转到新页面 -->
      <view 
        class="function-btn medical"
        @click="goToAiDiagnose"
      >
        <view class="icon-wrapper">
          <text class="fas fa-stethoscope"></text>
        </view>
        <view class="info">
          <text class="title">AI健康分析</text>
          <text class="desc">体质辨识 / 饮食建议</text>
        </view>
        <text class="fas fa-chevron-right"></text>
      </view>

      <view 
        class="function-btn chat"
        @click="showToast('AI陪聊已开启，您可以开始对话了...')"
      >
        <view class="icon-wrapper">
          <text class="fas fa-comment-dots"></text>
        </view>
        <view class="info">
          <text class="title">AI 陪聊</text>
          <text class="desc">讲笑话 / 读古诗</text>
        </view>
        <text class="fas fa-chevron-right"></text>
      </view>

      <view 
        class="function-btn radio"
        @click="showToast('正在为您播放经典戏曲...')"
      >
        <view class="icon-wrapper">
          <text class="fas fa-music"></text>
        </view>
        <view class="info">
          <text class="title">听广播</text>
          <text class="desc">戏曲 / 广场舞</text>
        </view>
        <text class="fas fa-chevron-right"></text>
      </view>
    </view>

    <!-- 家属管理入口 -->
    <view class="family-manage">
      <button class="manage-btn" @click="showInvitePopup = true">
        <text class="fas fa-users-gear"></text>
        <text>家属管理</text>
      </button>
    </view>

    <!-- 底部语音助手 -->
    <view class="voice-assistant">
      <view class="waveform">
        <view 
          v-for="(h, i) in [20, 40, 24, 32, 16]" 
          :key="i"
          class="wave"
          :style="{ height: h + 'px', animationDelay: i * 0.1 + 's' }"
        ></view>
      </view>
      <text class="tip">您可以直接说：“我想听戏”</text>
    </view>

    <!-- 邀请码生成弹窗 -->
    <view v-if="showInvitePopup" class="popup-overlay" @click="showInvitePopup = false">
      <view class="popup-content" @click.stop>
        <text class="popup-title">邀请家属</text>
        <view class="invite-code">{{ inviteCode }}</view>
        <text class="popup-tip">将此6位数字告诉家属，5分钟内有效</text>
        <button class="popup-btn copy-btn" @click="copyCode">复制邀请码</button>
        <button class="popup-btn close-btn" @click="showInvitePopup = false">关 闭</button>
      </view>
    </view>

    <!-- Toast提示 -->
    <view v-if="toastVisible" class="toast">{{ toastMessage }}</view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      currentTime: '',
      toastVisible: false,
      toastMessage: '',
      showInvitePopup: false,
      inviteCode: '------',
      // 模拟健康数据
      heartRate: 76,
      temperature: '36.5',
      constitution: '平和质',
    };
  },
  mounted() {
    this.updateTime();
    setInterval(this.updateTime, 1000);
    // 模拟数据更新
    setInterval(() => {
      this.heartRate = 70 + Math.floor(Math.random() * 10);
      this.temperature = (36.2 + Math.random() * 0.6).toFixed(1);
      const types = ['平和质', '气虚质', '阳虚质', '阴虚质'];
      this.constitution = types[Math.floor(Math.random() * types.length)];
    }, 5000);
  },
  methods: {
    updateTime() {
      const now = new Date();
      this.currentTime = now.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false
      });
    },
    showToast(msg) {
      this.toastMessage = msg;
      this.toastVisible = true;
      setTimeout(() => {
        this.toastVisible = false;
      }, 2000);
      // #ifdef APP-PLUS || H5
      if (navigator.vibrate) navigator.vibrate(30);
      // #endif
    },
    goToAiDiagnose() {
      uni.navigateTo({
        url: '/pages/elderly/AI_analyse'
      });
    },
    generateInviteCode() {
      uni.showLoading({ title: '生成中...' });
      setTimeout(() => {
        uni.hideLoading();
        this.inviteCode = Math.floor(100000 + Math.random() * 900000).toString();
      }, 500);
    },
    copyCode() {
      uni.setClipboardData({
        data: this.inviteCode,
        success: () => {
          this.showToast('邀请码已复制');
        }
      });
    }
  },
  watch: {
    showInvitePopup(val) {
      if (val) {
        this.generateInviteCode();
      }
    }
  }
};
</script>

<style scoped>
.elderly-page {
  min-height: 100vh;
  background-color: #f3f4f6;
  padding: 30rpx 30rpx 200rpx 30rpx;
  font-family: 'PingFang SC', sans-serif;
}

.status-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  background-color: #fff;
  border-radius: 20rpx;
  margin-bottom: 30rpx;
}
.status-item {
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 28rpx;
}
.status-item.connected {
  color: #166534;
}
.status-item .dot {
  width: 24rpx;
  height: 24rpx;
  background-color: #00b25e;
  border-radius: 50%;
  animation: pulse 1.5s infinite;
}
.time {
  font-size: 28rpx;
  color: #666;
}

/* 今日健康卡片 */
.health-card {
  background-color: white;
  border-radius: 30rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05);
}
.health-title {
  font-size: 36rpx;
  font-weight: bold;
  color: #2b7fff;
  display: block;
  margin-bottom: 20rpx;
}
.health-title .fas {
  margin-right: 10rpx;
}
.health-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
}
.health-item {
  text-align: center;
  background-color: #f8faff;
  padding: 20rpx;
  border-radius: 20rpx;
}
.health-item .label {
  font-size: 28rpx;
  color: #6b7280;
  display: block;
  margin-bottom: 10rpx;
}
.health-item .value {
  font-size: 48rpx;
  font-weight: bold;
  color: #1e2b3c;
  line-height: 1.2;
}
.health-item .unit {
  font-size: 24rpx;
  color: #9ca3af;
}

.function-buttons {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}
.function-btn {
  display: flex;
  align-items: center;
  padding: 40rpx;
  border-radius: 30rpx;
  color: #fff;
  gap: 30rpx;
}
.function-btn.emergency { background-color: #ef4444; }
.function-btn.medical { background-color: #10b981; }
.function-btn.chat { background-color: #6366f1; }
.function-btn.radio { background-color: #f97316; }
.icon-wrapper {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50%;
  background-color: rgba(255,255,255,0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 50rpx;
}
.info {
  flex: 1;
}
.title {
  font-size: 48rpx;
  font-weight: bold;
  display: block;
  margin-bottom: 10rpx;
}
.desc {
  font-size: 28rpx;
  opacity: 0.9;
}

.family-manage {
  margin: 40rpx 0 20rpx;
  display: flex;
  justify-content: center;
}
.manage-btn {
  background-color: #6b7280;
  border: none;
  border-radius: 60rpx;
  padding: 25rpx 60rpx;
  color: white;
  font-size: 36rpx;
  display: flex;
  align-items: center;
  gap: 15rpx;
  box-shadow: 0 6rpx 12rpx rgba(0,0,0,0.1);
}
.manage-btn:active {
  transform: scale(0.96);
  background-color: #4b5563;
}

.voice-assistant {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #fff;
  padding: 40rpx;
  border-radius: 40rpx 40rpx 0 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 -10rpx 40rpx rgba(0,0,0,0.1);
}
.waveform {
  display: flex;
  align-items: flex-end;
  gap: 10rpx;
  height: 80rpx;
  margin-bottom: 20rpx;
}
.wave {
  width: 15rpx;
  background-color: #3b82f6;
  border-radius: 10rpx;
  animation: bounce 1s infinite;
}
.tip {
  font-size: 32rpx;
  color: #3b82f6;
}

.popup-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}
.popup-content {
  background-color: white;
  border-radius: 40rpx;
  padding: 50rpx 40rpx;
  width: 80%;
  max-width: 600rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30rpx;
}
.popup-title {
  font-size: 48rpx;
  font-weight: bold;
  color: #1e2b3c;
}
.invite-code {
  font-size: 120rpx;
  font-weight: bold;
  background: #f0f0f0;
  padding: 40rpx 20rpx;
  border-radius: 30rpx;
  letter-spacing: 15rpx;
  width: 100%;
  text-align: center;
  color: #2b7fff;
}
.popup-tip {
  font-size: 32rpx;
  color: #6b7280;
  text-align: center;
}
.popup-btn {
  width: 100%;
  height: 90rpx;
  border-radius: 45rpx;
  font-size: 36rpx;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
}
.copy-btn {
  background-color: #2b7fff;
  color: white;
  border: none;
}
.copy-btn:active {
  background-color: #1a5fd0;
  transform: scale(0.96);
}
.close-btn {
  background-color: #e5e7eb;
  color: #374151;
}
.close-btn:active {
  background-color: #d1d5db;
}

.toast {
  position: fixed;
  top: 50rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(0,0,0,0.8);
  color: #fff;
  padding: 20rpx 60rpx;
  border-radius: 60rpx;
  font-size: 32rpx;
  z-index: 1000;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}
@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20rpx); }
}
</style>