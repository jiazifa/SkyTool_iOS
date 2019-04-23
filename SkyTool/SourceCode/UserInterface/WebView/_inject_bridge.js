function() {
   
    // 常量
    var CONSTANT = {
    ONINIT: "ONINIT"
    };
    
    var Bridge = {};
    
    __uniqueIndex = 0;
    Bridge.nativeCall = function(scheme, params, callback) {
        params = params ? decodeURI(JSON.stringify(params)) : "";
        
        const k = `${__uniqueIndex++}`;
        const handlerKey = Butils.getHandlerKey(k);
        
        _paramsStore.saveParams(handlerKey.p, params);
        if (callback !== null && callback != undefined) {
            _callbackStore.saveCallback(handlerKey.c, callback);
            Butils.addEvent(handlerKey.e, e => {
                            const { data, handler } = e.data;
                            Butils.removeEvent(handler);
                            callback.call(this, data);
                            });
        }
        
        // 发送协议请求
        send(`${scheme}?handler=${k}`);
    };
    
    var send = function(scheme) {
        setTimeout(() => {
                   // create iframe & set src
                   const iframe = document.createElement("iframe");
                   iframe.src = scheme;
                   iframe.style.display = "none";
                   document.body.appendChild(iframe);
                   
                   setTimeout(() => {
                              iframe.parentNode.removeChild(iframe);
                              }, 300);
                   }, 0);
        return this;
    };
    
    Bridge.postMessage = function(e) {
        // 客户端携带handler 和 data 调用postMessage
        const { handler, data } = e;
        
        const evName = Butils.getHandlerKey(handler).e;
        Butils.fireEvent(evName, data);
        return this;
    };
    
    // store
    var _paramsStore = {
    paramspool: {},
        
    saveParams: function(key, params) {
        this.paramspool[key] = params;
    },
    getParams: function(key) {
        return this.paramspool[key];
    }
    };
    
    var _callbackStore = {
    callbackpool: {},
        
    saveCallback: function(key, callback) {
        this.callbackpool[key] = callback;
    },
    getCallback: function(key) {
        return this.callbackpool[key];
    }
    };
    
    var _listenerStore = {
    listenerpool: {},
        
    saveListener: function(key, listener) {
        this.listenerpool[key] = listener;
    },
    getListener: function(key) {
        return this.listenerpool[key];
    },
    removeListener: function(key) {
        delete this.listenerpool.key;
    }
    };
    
    var __Native_getParams = function(rid) {
        var handle = Butils.getHandlerKey(rid);
        return _paramsStore.getParams(handle.p);
    };
    
    var Butils = {};
    Butils.getHandlerKey = function(k) {
        var o = {};
        o.p = `params_id${k}`;
        o.c = `callback_id${k}`;
        o.e = `eventKey_id${k}`;
        return o;
    };
    
    Butils.addEvent = function(type, callback) {
        document.addEventListener(type, callback);
    };
    
    Butils.removeEvent = function(type) {
        document.removeEventListener(type, () => {});
    };
    
    Butils.fireEvent = function(type, data) {
        var d = {
        data: data,
        handler: type
        };
        var e = new Event(type, d);
        e.data = d;
        document.dispatchEvent(e);
    };

}();
