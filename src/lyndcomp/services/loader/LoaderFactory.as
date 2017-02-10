/**
 * Created by zear19st on 2016/12/16.
 */
package lyndcomp.services.loader
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    import lyndcomp.services.loader.modules.ILoaderModule;
    import lyndcomp.tool.util;

    public class LoaderFactory implements ILoaderFactory
    {
        private var moduleDict:Dictionary;
        private var callbackDict:Dictionary;
        private var callbackErrorDict:Dictionary;
        private var loadedDict:Dictionary;

        public function LoaderFactory()
        {
            moduleDict = new Dictionary();
            callbackDict = new Dictionary(true);
            callbackErrorDict = new Dictionary(true);
            loadedDict = new Dictionary();
        }

        public function register(modules:Object):void
        {
            for (var name:String in modules)
            {
                if (util.hasInterface(modules[name], ILoaderModule))
                {
                    moduleDict[name] = new modules[name](name);
                }
            }
        }

        public function getLoader(type:String):ILoaderFactory
        {
            return moduleDict[type];
        }

        public function load(type:String, path:String, config:Object, container:*, callback:Function):void
        {
            var loaderModule:ILoaderModule = moduleDict[type];
            if (loaderModule == null)
                return;
            if (loaderModule.isLoaded(loadedDict, path, config))
            {
                callback.apply(null, [true, container, loaderModule.getLoaded(loadedDict, path, config)]);
                return;
            }

            try
            {
                var realPath:String = loaderModule.getPath(path, config);
                var urlRequest:URLRequest = new URLRequest(realPath);
                var loader:Loader = new Loader();
                callbackDict[loader] = getOnLoaded(container, loaderModule, path, config, callback);
                callbackErrorDict[loader] = getErrorLoaded(container, loaderModule, callback)
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callbackDict[loader]);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, callbackErrorDict[loader]);
                loader.load(urlRequest);
            }
            catch (err:Error)
            {
                trace("loading error:", err.message);
            }
        }

        private function getErrorLoaded(container:*, loaderModule:ILoaderModule, callback:Function):Function
        {
            var fn:Function = function (e:IOErrorEvent):void
            {
                var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
                loaderInfo.removeEventListener(Event.COMPLETE, callbackDict[loaderInfo.loader]);
                loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, callbackErrorDict[loaderInfo.loader]);
                callbackDict[loaderInfo.loader] = null;
                callbackErrorDict[loaderInfo.loader] = null;
                callback.apply(null, [false, container, null]);
            }
            return fn;
        }

        private function getOnLoaded(container:*, loaderModule:ILoaderModule, path:String, config:Object, callback:Function):Function
        {
            var fn:Function = function (e:Event):void
            {
                var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
                loaderInfo.removeEventListener(Event.COMPLETE, callbackDict[loaderInfo.loader]);
                loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, callbackErrorDict[loaderInfo.loader]);
                callbackDict[loaderInfo.loader] = null;
                callbackErrorDict[loaderInfo.loader] = null;
                callback.apply(null, [true, container, loaderModule.loaded(loadedDict, path, config, loaderInfo)]);
                loaderInfo.loader.unload();
            }
            return fn;
        }
    }
}
