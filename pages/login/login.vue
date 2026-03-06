<template>
  <view class="login-container">
    <view class="login-card">
      <!-- 品牌标识 -->
      <view class="brand">
        <view class="brand-icon">
          <text class="fas fa-hand-holding-heart"></text>
        </view>
        <text class="brand-title">智护银龄</text>
        <text class="brand-sub">欢迎回来</text>
      </view>

      <!-- 角色选择（适老化大按钮） -->
      <view class="role-selector">
        <view 
          class="role-option" 
          :class="{ active: loginRole === 'elderly' }"
          @click="loginRole = 'elderly'"
        >
          <text class="fas fa-user"></text>
          <text>老人端</text>
        </view>
        <view 
          class="role-option" 
          :class="{ active: loginRole === 'family' }"
          @click="loginRole = 'family'"
        >
          <text class="fas fa-users"></text>
          <text>家属端</text>
        </view>
      </view>

      <!-- 账号输入 -->
      <view class="input-group">
        <text class="input-label">账号</text>
        <view class="input-field">
          <text class="fas fa-user"></text>
          <input
            type="text"
            v-model="username"
            placeholder="请输入手机号/身份证号"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 密码输入 -->
      <view class="input-group">
        <text class="input-label">密码</text>
        <view class="input-field">
          <text class="fas fa-lock"></text>
          <input
            type="password"
            v-model="password"
            placeholder="请输入密码"
            placeholder-class="placeholder"
          />
        </view>
      </view>

      <!-- 登录按钮 -->
      <button class="login-btn" @click="handleLogin">
        <text class="fas fa-arrow-right-to-bracket"></text>
        <text>登 录</text>
      </button>

      <!-- 忘记密码 & 注册 -->
      <view class="helper-text">
        <view class="helper-item" @click="handleForget">
          <text class="fas fa-question-circle"></text>
          <text>忘记密码？</text>
        </view>
        <view class="helper-item" @click="goToRegister">
          <text class="fas fa-user-plus"></text>
          <text>注册账号</text>
        </view>
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
      username: '',
      password: '',
      loginRole: 'elderly', // 默认老人端
      toastVisible: false,
      toastMessage: '',
    };
  },
  methods: {
    showToast(msg) {
      this.toastMessage = msg;
      this.toastVisible = true;
      setTimeout(() => {
        this.toastVisible = false;
      }, 2000);
      // 震动反馈
      // #ifdef APP-PLUS || H5
      if (navigator.vibrate) navigator.vibrate(30);
      // #endif
    },
    // handleLogin() {
    //   if (!this.username || !this.password) {
    //     this.showToast('请输入账号和密码');
    //     return;
    //   }
    //   // 模拟登录成功，跳转到首页（index），并传递角色参数
    //   // 可以使用 uni.navigateTo 或 uni.switchTab（如果首页是 tab 页）
    //   uni.navigateTo({
    //      url: `/pages/index/index?role=${this.loginRole}`
    //   });
    // },
	handleLogin() {
		if (!this.username || !this.password) {
		    this.showToast('请输入账号和密码');
		    return;
		}
	  // 演示：直接跳转，不校验账号密码
	  const role = this.loginRole; // 假设 loginRole 是 data 中定义的，值为 'elderly' 或 'family'
	  uni.navigateTo({
	    url: role === 'elderly' ? '/pages/index/elderly' : '/pages/index/family',
	    fail: (err) => {
	      console.error('跳转失败', err);
	      uni.showToast({
	        title: '页面跳转失败，请检查配置',
	        icon: 'none'
	      });
	    }
	  });
	},
    handleForget() {
      this.showToast('已提醒家人重置密码');
    },
    goToRegister() {
      uni.navigateTo({
        url: '/pages/login/register'
      });
    }
	
  }
};
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  background-color: #f0f2f5;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 30rpx;
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

.login-card {
  width: 100%;
  max-width: 650rpx;
  background-color: white;
  border-radius: 60rpx;
  padding: 60rpx 40rpx;
  box-shadow: 0 20rpx 50rpx rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  gap: 40rpx;
}

/* 品牌区 */
.brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20rpx;
  margin-bottom: 10rpx;
}
.brand-icon {
  width: 160rpx;
  height: 160rpx;
  background: linear-gradient(145deg, #2b7fff, #0055cc);
  border-radius: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 80rpx;
  box-shadow: 0 10rpx 20rpx rgba(0, 85, 204, 0.3);
}
.brand-title {
  font-size: 48rpx;
  font-weight: bold;
  color: #1e2b3c;
}
.brand-sub {
  font-size: 32rpx;
  color: #5e6f8d;
}

/* 角色选择器 */
.role-selector {
  display: flex;
  gap: 30rpx;
  justify-content: center;
}
.role-option {
  flex: 1;
  background-color: #f0f4fa;
  border-radius: 30rpx;
  padding: 30rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10rpx;
  border: 4rpx solid transparent;
  transition: all 0.2s;
  font-size: 32rpx;
  color: #3a4a5e;
}
.role-option text:first-child {
  font-size: 48rpx;
}
.role-option.active {
  background-color: #e6f0ff;
  border-color: #2b7fff;
  color: #2b7fff;
  font-weight: bold;
}

/* 输入组 */
.input-group {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}
.input-label {
  font-size: 32rpx;
  font-weight: 500;
  color: #2c3e50;
  margin-left: 10rpx;
}
.input-field {
  display: flex;
  align-items: center;
  background-color: #f8faff;
  border: 2rpx solid #d9e2ef;
  border-radius: 30rpx;
  padding: 0 30rpx;
  transition: all 0.2s;
}
.input-field:focus-within {
  border-color: #2b7fff;
  box-shadow: 0 0 0 6rpx rgba(43, 127, 255, 0.2);
  background-color: white;
}
.input-field text {
  font-size: 36rpx;
  color: #7b8cae;
  width: 60rpx;
  text-align: center;
}
.input-field input {
  flex: 1;
  height: 100rpx;
  font-size: 36rpx;
  background: transparent;
  border: none;
  padding-left: 20rpx;
}
.placeholder {
  color: #a6b8d0;
  font-size: 32rpx;
}

/* 登录按钮 */
.login-btn {
  background-color: #2b7fff;
  border: none;
  border-radius: 50rpx;
  height: 120rpx;
  color: white;
  font-size: 40rpx;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20rpx;
  margin-top: 20rpx;
  box-shadow: 0 12rpx 30rpx rgba(43, 127, 255, 0.4);
  transition: transform 0.1s;
}
.login-btn:active {
  transform: scale(0.96);
  background-color: #1a5fd0;
}
.login-btn text:first-child {
  font-size: 44rpx;
}

/* 辅助行：忘记密码和注册 */
.helper-text {
  display: flex;
  justify-content: space-around;
  align-items: center;
  font-size: 32rpx;
  color: #6f7d98;
  margin-top: 20rpx;
}
.helper-item {
  display: flex;
  align-items: center;
  gap: 10rpx;
  padding: 20rpx 30rpx;
  background-color: #f5f7fa;
  border-radius: 60rpx;
  color: #2b7fff;
}
.helper-item text:first-child {
  font-size: 36rpx;
}

/* Toast */
.toast {
  position: fixed;
  bottom: 100rpx;
  left: 50%;
  transform: translateX(-50%);
  background-color: #1e2b3c;
  color: white;
  padding: 20rpx 60rpx;
  border-radius: 60rpx;
  font-size: 32rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.3);
  z-index: 999;
}
</style>