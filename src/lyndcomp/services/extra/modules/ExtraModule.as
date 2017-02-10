/**
 * Created by zear19st on 2016/12/29.
 */
package lyndcomp.services.extra.modules
{
    import flash.utils.Dictionary;

    public class ExtraModule implements IExtraModule
    {
        public static const CHANGE_SCREEN:String = "change_screen";

        private var _weight:int;
        private var _type:String;

        protected var _isFullScreen:Boolean;
        protected var _root:*;

        private var _callbackDict:Dictionary;

        public function ExtraModule(type:String, root:*, weight:int)
        {
            _weight = weight;
            _type = type;
            _isFullScreen = false;
            _callbackDict = new Dictionary();
            _root = root;
            init(root);
        }

        protected function init(root:*):void
        {
        }

        public function getPath():String
        {
            return "";
        }

        public function canBeUsed():Boolean
        {
            return false;
        }

        public function getThisFormWidth():Number
        {
            return 0;
        }

        public function getThisFormHeight():Number
        {
            return 0;
        }

        public function fullScreen(isFullScreen:Boolean):void
        {
        }

        public function setCallback(type:String, callback:Function):void
        {
            if (_callbackDict[type] == null)
                _callbackDict[type] = new Dictionary();
            _callbackDict[type][callback] = callback;
        }

        private function activeCallback(callback:Function):Function
        {
            var fn:Function = function (data:Object):void
            {
                callback.apply(null, [data]);
            }
            return fn;
        }

        final public function hasCallback(type:String, callback:Function):Boolean
        {
            if (_callbackDict[type] == null)
                return false;
            if (_callbackDict[type][callback] == null)
                return false;
            return true;
        }

        final public function removeCallback(type:String, callback:Function):void
        {
            if (_callbackDict[type] == null)
                return;
            if (_callbackDict[type][callback] == null)
                return;
            _callbackDict[type][callback] = null;
        }

        final public function executeCallback(type:String, data:Object):void
        {
            if (_callbackDict[type] == null)
                return;
            for (var key:* in _callbackDict[type])
            {
                _callbackDict[type][key].apply(null, [data]);
            }
        }

        public function get isFullScreen():Boolean
        {
            return _isFullScreen;
        }

        public function folderExists(folderPath:String):Boolean
        {
            return false;
        }

        public function getFileList(filePath:String, fileType:String):Array
        {
            return null;
        }

        public function prompt(message:String):void
        {
        }

        public function get weight():int
        {
            return _weight;
        }

        public function get type():String
        {
            return _type;
        }

        public function exit():void
        {
        }

        public function getCMDParams(cmdID:Number):String
        {
            return "";
        }
    }
}
