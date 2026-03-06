<template>
  <view class="app-container">
    <!-- 角色切换区 -->
    <view class="control-bar">
      <view class="text-gray-500 text-sm flex items-center gap-2 mb-2">
        <text class="fas fa-eye w-4 h-4"></text>
        <text>请切换演示视角</text>
      </view>
      <view class="role-tabs">
        <view 
          class="tab" 
          :class="role === 'elderly' ? 'active' : ''"
          @click="setRole('elderly')"
        >
          老人端
        </view>
        <view 
          class="tab" 
          :class="role === 'family' ? 'active' : ''"
          @click="setRole('family')"
        >
          家属端
        </view>
      </view>
    </view>

    <!-- 老人端界面 -->
    <view v-if="role === 'elderly'" class="elderly-page">
      <!-- 顶部状态栏 -->
      <view class="status-bar">
        <view class="status-item connected">
          <view class="dot"></view>
          <text>已连接</text>
        </view>
        <text class="time">{{ currentTime }}</text>
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

        <view 
          class="function-btn medical"
          @click="showToast('正在为您接入在线医生，请稍候...')"
        >
          <view class="icon-wrapper">
            <text class="fas fa-stethoscope"></text>
          </view>
          <view class="info">
            <text class="title">看名医</text>
            <text class="desc">AI面诊 / 测心率</text>
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
    </view>

    <!-- 家属端界面 -->
    <view v-else class="family-page">
      <!-- 顶部标题栏 -->
      <view class="header-bar">
        <text class="title">父母健康守护</text>
        <text class="time">{{ currentTime }}</text>
      </view>

      <!-- 监控卡片 -->
      <view class="monitor-card">
        <view class="monitor-header">
          <view class="live-badge">LIVE</view>
          <view class="privacy-badge">隐私模式</view>
        </view>
        <text class="monitor-status">客厅摄像头 | 状态：{{ cameraStatus }}</text>
      </view>

      <!-- 体征数据 -->
      <view class="vitals-grid">
        <view class="vital-item">
          <text class="fas fa-heart heart-icon"></text>
          <text class="value">{{ heartRate }}</text>
          <text class="unit">bpm</text>
        </view>
        <view class="vital-item">
          <text class="fas fa-wind breath-icon"></text>
          <text class="value">{{ breathRate }}</text>
          <text class="unit">次/分</text>
        </view>
        <view class="vital-item">
          <text class="fas fa-temperature-high temp-icon"></text>
          <text class="value">{{ temperature }}</text>
          <text class="unit">°C</text>
        </view>
      </view>

      <!-- 体质周报 -->
      <view 
        class="tcm-report"
        @click="showToast('已为您生成详细的体质分析报告')"
      >
        <view class="report-header">
          <text class="report-title">中医体质周报</text>
          <view class="ai-badge">AI 智能解读</view>
        </view>
        <view class="report-content">
          <view class="score">92</view>
          <view class="report-info">
            <text class="type">体质类型：平和质</text>
            <text class="suggestion">建议：今日气温较低，注意保暖。</text>
          </view>
        </view>
      </view>

      <!-- 紧急联系按钮 -->
      <view 
        class="emergency-contact"
        @click="showToast('已向老人发送紧急提醒，并准备视频通话')"
      >
        <text class="fas fa-exclamation-circle"></text>
        <text>紧急联系老人</text>
      </view>
    </view>

    <!-- 提示弹窗 -->
    <view v-if="toastVisible" class="toast">
      {{ toastMessage }}
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';

const role = ref('elderly');
const toastVisible = ref(false);
const toastMessage = ref('');
const heartRate = ref(76);
const breathRate = ref(18);
const temperature = ref(36.5);
const cameraStatus = ref('静坐阅读');
const statusList = ['静坐阅读', '慢走活动', '饮水休息', '观看电视', '用餐中'];

const currentTime = computed(() => {
  const now = new Date();
  return now.toLocaleTimeString('zh-CN', { 
    hour: '2-digit', 
    minute: '2-digit',
    hour12: false 
  });
});

const setRole = (newRole) => {
  role.value = newRole;
  cameraStatus.value = statusList[Math.floor(Math.random() * statusList.length)];
};

const showToast = (message) => {
  toastMessage.value = message;
  toastVisible.value = true;
  setTimeout(() => {
    toastVisible.value = false;
  }, 2000);
  // #ifdef APP-PLUS || H5
  if (navigator.vibrate) navigator.vibrate(30);
  // #endif
};

onMounted(() => {
  setInterval(() => {
    heartRate.value = 70 + Math.floor(Math.random() * 10);
    breathRate.value = 16 + Math.floor(Math.random() * 4);
    temperature.value = (36.2 + Math.random() * 0.6).toFixed(1);
  }, 4000);
});
</script>

<style scoped>
/* 保持原有的样式完全不变，只需确保图标类已替换为 Font Awesome */
.app-container {
  min-height: 100vh;
  background-color: #f3f4f6;
  font-family: sans-serif;
}

.control-bar {
  padding: 20rpx;
  background-color: #fff;
  border-bottom: 1px solid #eee;
}
.role-tabs {
  display: flex;
  background-color: #f5f5f5;
  border-radius: 10rpx;
  padding: 8rpx;
}
.tab {
  flex: 1;
  text-align: center;
  padding: 16rpx 0;
  border-radius: 8rpx;
  font-size: 28rpx;
  color: #666;
  transition: all 0.3s;
}
.tab.active {
  background-color: #fff;
  color: #3b82f6;
  font-weight: bold;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1);
}

.elderly-page {
  padding: 20rpx;
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
  font-size: 24rpx;
}
.status-item.connected {
  color: #166534;
}
.status-item .dot {
  width: 20rpx;
  height: 20rpx;
  background-color: #00b25e;
  border-radius: 50%;
  animation: pulse 1.5s infinite;
}
.time {
  font-size: 24rpx;
  color: #666;
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
  font-size: 40rpx;
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

.family-page {
  padding: 20rpx;
}
.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx;
  background-color: #fff;
  border-radius: 20rpx;
  margin-bottom: 30rpx;
}
.header-bar .title {
  font-size: 36rpx;
  font-weight: bold;
}
.monitor-card {
  background-color: #000;
  color: #fff;
  padding: 30rpx;
  border-radius: 30rpx;
  margin-bottom: 30rpx;
  height: 300rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.monitor-header {
  display: flex;
  justify-content: space-between;
}
.live-badge {
  background-color: #ef4444;
  padding: 8rpx 16rpx;
  border-radius: 6rpx;
  font-size: 20rpx;
  font-weight: bold;
  animation: pulse 1.5s infinite;
}
.privacy-badge {
  border: 1px solid #10b981;
  color: #10b981;
  padding: 8rpx 16rpx;
  border-radius: 6rpx;
  font-size: 20rpx;
}
.monitor-status {
  font-size: 24rpx;
  opacity: 0.8;
}
.vitals-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
  margin-bottom: 30rpx;
}
.vital-item {
  background-color: #fff;
  padding: 40rpx;
  border-radius: 30rpx;
  text-align: center;
}
.heart-icon { color: #ef4444; font-size: 40rpx; margin-bottom: 10rpx; animation: pulse 1.5s infinite; }
.breath-icon { color: #3b82f6; font-size: 40rpx; margin-bottom: 10rpx; }
.temp-icon { color: #f97316; font-size: 40rpx; margin-bottom: 10rpx; }
.value {
  font-size: 48rpx;
  font-weight: bold;
  display: block;
}
.unit {
  font-size: 24rpx;
  color: #666;
}
.tcm-report {
  background-color: #fff;
  padding: 40rpx;
  border-radius: 30rpx;
  margin-bottom: 30rpx;
}
.report-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}
.report-title {
  font-size: 32rpx;
  font-weight: bold;
}
.ai-badge {
  background-color: #f3e8ff;
  color: #8b5cf6;
  padding: 8rpx 16rpx;
  border-radius: 20rpx;
  font-size: 20rpx;
}
.report-content {
  display: flex;
  align-items: center;
  gap: 30rpx;
}
.score {
  width: 120rpx;
  height: 120rpx;
  border-radius: 50%;
  background-color: #ecfdf5;
  color: #10b981;
  font-size: 48rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 8rpx solid #a7f3d0;
  animation: pulse 1.5s infinite;
}
.report-info {
  flex: 1;
}
.type {
  font-size: 28rpx;
  color: #666;
  display: block;
  margin-bottom: 10rpx;
}
.suggestion {
  font-size: 24rpx;
  color: #999;
}
.emergency-contact {
  background-color: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.2);
  color: #ef4444;
  padding: 30rpx;
  border-radius: 30rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20rpx;
  font-size: 32rpx;
  font-weight: 500;
}
.toast {
  position: fixed;
  top: 50rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(0,0,0,0.8);
  color: #fff;
  padding: 20rpx 40rpx;
  border-radius: 40rpx;
  font-size: 28rpx;
  z-index: 999;
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