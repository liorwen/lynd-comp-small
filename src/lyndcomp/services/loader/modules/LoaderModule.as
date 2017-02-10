/**
 * Created by zear19st on 2016/12/22.
 */
package lyndcomp.services.loader.modules
{
    import flash.display.LoaderInfo;
    import flash.utils.Dictionary;

    public class LoaderModule implements ILoaderModule
    {
        private var _type:String;

        public function LoaderModule(type:String)
        {
            _type = type;
        }

        public function getPath(path:String, config:Object):String
        {
            return "";
        }

        public function loaded(loadedDict:Dictionary, path:String, config:Object, loaderInfo:LoaderInfo):*
        {
            return null;
        }

        public function get type():String
        {
            return _type;
        }

        public function isLoaded(loadedDict:Dictionary, path:String, config:Object):Boolean
        {
            return false;
        }

        public function getLoaded(loadedDict:Dictionary, path:String, config:Object):*
        {
            return null;
        }

        public function getKey(path:String, config:Object, option:String):String
        {
            return "";
        }
    }
}
