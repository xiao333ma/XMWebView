var __inject_func_name___MessageChannelMap = {};
function __inject_func_name__(parameters) {
    var channel = new MessageChannel(); // 创建一个 MessageChannel
    if(!window.__native_callback_name__) {
        window.__native_callback_name__ = {};
    }
    var id = parameters.name + "_" + Math.random();
    parameters.id = id;
    __inject_func_name___MessageChannelMap[id] = channel;
    window.__native_callback_name__[parameters.name] = function(nativeValue) {
        if (nativeValue.id && __inject_func_name___MessageChannelMap[nativeValue.id]) {
            __inject_func_name___MessageChannelMap[nativeValue.id].port1.postMessage(nativeValue);
            delete __inject_func_name___MessageChannelMap[nativeValue.id];
        }
    };
    window.webkit.messageHandlers.__inject_func_name__.postMessage(parameters);
    return new Promise(function(resolve, reject) {
        channel.port2.onmessage = function(e) {
            var data = e.data;
            resolve(data);
            channel = null;
        };
    });
}
