var __message_queue_prefix___MessageQueue = {};
function __inject_func_name__(parameters) {
    var channel = new MessageChannel(); // 创建一个 MessageChannel
    if(!window.__native_callback_name__) {
        window.__native_callback_name__ = {};
    }
    var id = parameters.name + "_" + Math.random();
    parameters.id = id;
    __message_queue_prefix___MessageQueue[id] = channel;
    window.__native_callback_name__[parameters.name] = function(nativeValue) {
        if (nativeValue.id && __message_queue_prefix___MessageQueue[nativeValue.id]) {
            __message_queue_prefix___MessageQueue[nativeValue.id].port1.postMessage(nativeValue);
            delete __message_queue_prefix___MessageQueue[nativeValue.id];
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
