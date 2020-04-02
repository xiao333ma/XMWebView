# XMWebView

[![CI Status](https://img.shields.io/travis/xiao3333ma@gmail.com/XMWebView.svg?style=flat)](https://travis-ci.org/xiao3333ma@gmail.com/XMWebView)
[![Version](https://img.shields.io/cocoapods/v/XMWebView.svg?style=flat)](https://cocoapods.org/pods/XMWebView)
[![License](https://img.shields.io/cocoapods/l/XMWebView.svg?style=flat)](https://cocoapods.org/pods/XMWebView)
[![Platform](https://img.shields.io/cocoapods/p/XMWebView.svg?style=flat)](https://cocoapods.org/pods/XMWebView)

一个轻量级的 Hybrid 框架

![info](./info.png)

webView 启动时 Native 主动注入一段 JS，来让 JS 调用 Native，Native 回调时会调用 `window.XM_NativeCallBackNameMap.funcName(params)` 来触发 MessageChannel 的 port1 发送消息，在 promise 中的 port2 的 onmessage 会被调用，然后执行 resolve 

``` js
var XM_JS2Native_MessageQueue = {};
function XM_JS2Native(parameters) {
    var channel = new MessageChannel(); // 创建一个 MessageChannel
    if(!window.XM_NativeCallBackNameMap) {
        window.XM_NativeCallBackNameMap = {};
    }
    var id = parameters.name + "_" + Math.random();
    parameters.id = id;
    XM_JS2Native_MessageQueue[id] = channel;

    window.XM_NativeCallBackNameMap[parameters.name] = function(nativeValue) {
        if (nativeValue.id && XM_JS2Native_MessageQueue[nativeValue.id]) {
            XM_JS2Native_MessageQueue[nativeValue.id].port1.postMessage(nativeValue);
            delete XM_JS2Native_MessageQueue[nativeValue.id];
        }
    };
    window.webkit.messageHandlers.XM_JS2Native.postMessage(parameters);
    return new Promise(function(resolve, reject) {
        channel.port2.onmessage = function(e) {
            var data = e.data;
            resolve(data);
            channel = null;
        };
    });
}
```
