<template>
  <view class="family-page">
    <!-- 顶部标题栏，增加老人切换器 -->
    <view class="header-bar">
      <view class="header-left">
        <text class="title">父母健康守护</text>
        <!-- 老人切换下拉框 -->
        <view class="elderly-selector" @click="showElderlyPicker = true">
          <text class="selected-name">{{ currentElderly?.name || '选择老人' }}</text>
          <text class="fas fa-chevron-down"></text>
        </view>
      </view>
      <view class="header-right">
        <text class="time">{{ currentTime }}</text>
        <text class="fas fa-user-circle profile-icon" @click="goToProfile"></text>
      </view>
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
        <view class="score">{{ tcmScore }}</view>
        <view class="report-info">
          <text class="type">体质类型：{{ tcmType }}</text>
          <text class="suggestion">{{ tcmSuggestion }}</text>
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

    <!-- 老人选择弹窗（底部滑出） -->
    <view v-if="showElderlyPicker" class="picker-overlay" @click="showElderlyPicker = false">
      <view class="picker-content" @click.stop>
        <text class="picker-title">选择老人</text>
        <scroll-view class="picker-list" scroll-y>
          <view 
            v-for="item in elderlyList" 
            :key="item.id"
            class="picker-item"
            :class="{ active: currentElderly?.id === item.id }"
            @click="selectElderly(item)"
          >
            <text class="item-name">{{ item.name }}</text>
            <text class="item-relation">{{ item.relation }}</text>
            <text v-if="currentElderly?.id === item.id" class="fas fa-check check-icon"></text>
          </view>
        </scroll-view>
        <button class="picker-close" @click="showElderlyPicker = false">取 消</button>
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
      elderlyList: [],
      currentElderly: null,
      heartRate: 0,
      breathRate: 0,
      temperature: 0,
      cameraStatus: '',
      tcmScore: 92,
      tcmType: '平和质',
      tcmSuggestion: '建议：今日气温较低，注意保暖。',
      statusList: ['静坐阅读', '慢走活动', '饮水休息', '观看电视', '用餐中'],
      toastVisible: false,
      toastMessage: '',
      showElderlyPicker: false
    };
  },
  mounted() {
    this.updateTime();
    setInterval(this.updateTime, 1000);
    this.loadElderlyList();
    // 监听个人中心页的刷新事件
    uni.$on('refreshElderlyList', this.loadElderlyList);
  },
  onUnload() {
    uni.$off('refreshElderlyList', this.loadElderlyList);
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
    loadElderlyList() {
      // 模拟 API 请求
      uni.showLoading({ title: '加载中...' });
      setTimeout(() => {
        uni.hideLoading();
        this.elderlyList = [
          { id: 1, name: '张爷爷', relation: '父亲' },
          { id: 2, name: '王奶奶', relation: '母亲' }
        ];
        if (this.elderlyList.length > 0) {
          const lastId = uni.getStorageSync('lastElderlyId');
          const last = this.elderlyList.find(item => item.id === lastId);
          this.currentElderly = last || this.elderlyList[0];
          this.loadElderlyData(this.currentElderly.id);
        }
      }, 500);
    },
    loadElderlyData(elderlyId) {
      // 模拟 API 请求
      uni.showLoading({ title: '刷新数据...' });
      setTimeout(() => {
        uni.hideLoading();
        this.heartRate = 70 + Math.floor(Math.random() * 10);
        this.breathRate = 16 + Math.floor(Math.random() * 4);
        this.temperature = (36.2 + Math.random() * 0.6).toFixed(1);
        this.cameraStatus = this.statusList[Math.floor(Math.random() * this.statusList.length)];
        this.tcmScore = 90 + Math.floor(Math.random() * 8);
        this.tcmType = ['平和质', '气虚质', '阳虚质'][Math.floor(Math.random() * 3)];
        this.tcmSuggestion = '建议：今日气温较低，注意保暖。';
      }, 500);
    },
    selectElderly(item) {
      this.currentElderly = item;
      this.showElderlyPicker = false;
      uni.setStorageSync('lastElderlyId', item.id);
      this.loadElderlyData(item.id);
    },
    goToProfile() {
      uni.navigateTo({
        url: '/pages/family/family_home'
      });
    }
  }
};
</script>

<style scoped>
.family-page {
  min-height: 100vh;
  background-color: #f3f4f6;
  padding: 30rpx 30rpx 120rpx 30rpx;
  font-family: 'PingFang SC', sans-serif;
}

.header-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx;
  background-color: #fff;
  border-radius: 40rpx;
  margin-bottom: 30rpx;
}
.header-left {
  display: flex;
  flex-direction: column;
  gap: 10rpx;
}
.header-left .title {
  font-size: 40rpx;
  font-weight: bold;
}
.elderly-selector {
  display: flex;
  align-items: center;
  gap: 10rpx;
  background-color: #f0f4fa;
  padding: 10rpx 30rpx 10rpx 20rpx;
  border-radius: 60rpx;
  align-self: flex-start;
}
.elderly-selector .selected-name {
  font-size: 32rpx;
  font-weight: 500;
  color: #2b7fff;
}
.elderly-selector .fas {
  font-size: 28rpx;
  color: #6b7280;
}
.header-right {
  display: flex;
  align-items: center;
  gap: 20rpx;
}
.header-right .time {
  font-size: 28rpx;
  color: #666;
}
.profile-icon {
  font-size: 50rpx;
  color: #2b7fff;
  padding: 10rpx;
}
.profile-icon:active {
  opacity: 0.7;
}

.monitor-card {
  background-color: #000;
  color: #fff;
  padding: 30rpx;
  border-radius: 40rpx;
  height: 340rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  margin-bottom: 30rpx;
}
.monitor-header {
  display: flex;
  justify-content: space-between;
}
.live-badge {
  background-color: #ef4444;
  padding: 10rpx 20rpx;
  border-radius: 30rpx;
  font-size: 24rpx;
  font-weight: bold;
  animation: pulse 1.5s infinite;
}
.privacy-badge {
  border: 2rpx solid #10b981;
  color: #10b981;
  padding: 10rpx 20rpx;
  border-radius: 30rpx;
  font-size: 24rpx;
}
.monitor-status {
  font-size: 28rpx;
  opacity: 0.9;
}

.vitals-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20rpx;
  margin-bottom: 30rpx;
}
.vital-item {
  background-color: #fff;
  padding: 30rpx 10rpx;
  border-radius: 30rpx;
  text-align: center;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05);
}
.vital-item .fas {
  font-size: 48rpx;
  margin-bottom: 10rpx;
  display: block;
}
.heart-icon { color: #ef4444; animation: pulse 1.5s infinite; }
.breath-icon { color: #3b82f6; }
.temp-icon { color: #f97316; }
.value {
  font-size: 48rpx;
  font-weight: bold;
  display: block;
}
.unit {
  font-size: 26rpx;
  color: #6b7280;
}

.tcm-report {
  background-color: #fff;
  padding: 30rpx;
  border-radius: 40rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05);
}
.report-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}
.report-title {
  font-size: 36rpx;
  font-weight: bold;
}
.ai-badge {
  background-color: #f3e8ff;
  color: #8b5cf6;
  padding: 8rpx 24rpx;
  border-radius: 40rpx;
  font-size: 24rpx;
}
.report-content {
  display: flex;
  align-items: center;
  gap: 30rpx;
}
.score {
  width: 140rpx;
  height: 140rpx;
  border-radius: 50%;
  background-color: #ecfdf5;
  color: #10b981;
  font-size: 56rpx;
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
  font-size: 32rpx;
  color: #374151;
  display: block;
  margin-bottom: 10rpx;
}
.suggestion {
  font-size: 28rpx;
  color: #6b7280;
}

.emergency-contact {
  background-color: rgba(239, 68, 68, 0.1);
  border: 2rpx solid rgba(239, 68, 68, 0.2);
  color: #ef4444;
  padding: 30rpx;
  border-radius: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20rpx;
  font-size: 36rpx;
  font-weight: 500;
  margin-bottom: 30rpx;
}

.picker-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  align-items: flex-end;
  z-index: 1000;
}
.picker-content {
  background-color: white;
  width: 100%;
  border-radius: 60rpx 60rpx 0 0;
  padding: 40rpx 30rpx 60rpx;
  max-height: 70vh;
  display: flex;
  flex-direction: column;
}
.picker-title {
  font-size: 40rpx;
  font-weight: bold;
  text-align: center;
  margin-bottom: 30rpx;
  color: #1e2b3c;
}
.picker-list {
  flex: 1;
  max-height: 500rpx;
}
.picker-item {
  display: flex;
  align-items: center;
  padding: 30rpx;
  border-bottom: 2rpx solid #f3f4f6;
  position: relative;
}
.picker-item.active {
  background-color: #f0f7ff;
}
.item-name {
  font-size: 40rpx;
  font-weight: 500;
  margin-right: 20rpx;
}
.item-relation {
  font-size: 32rpx;
  color: #6b7280;
}
.check-icon {
  position: absolute;
  right: 30rpx;
  color: #2b7fff;
  font-size: 40rpx;
}
.picker-close {
  margin-top: 30rpx;
  background-color: #e5e7eb;
  color: #374151;
  border: none;
  border-radius: 60rpx;
  height: 90rpx;
  font-size: 36rpx;
}

.toast {
  position: fixed;
  top: 50rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: rgba(0,0,0,0.8);
  color: white;
  padding: 20rpx 60rpx;
  border-radius: 60rpx;
  font-size: 32rpx;
  z-index: 1000;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}
</style>