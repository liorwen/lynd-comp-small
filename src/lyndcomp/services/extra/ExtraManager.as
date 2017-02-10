/**
 * Created by zear19st on 2016/12/29.
 */
package lyndcomp.services.extra
{
    import lyndcomp.services.extra.modules.IExtraModule;

    public class ExtraManager extends ExtraFactory implements IExtraModule
    {
        private var _modules:Vector.<IExtraModule>;

        public function ExtraManager()
        {
            super();
            _modules = new Vector.<IExtraModule>();
        }


        override public function register(root:*, modules:Object):void
        {
            super.register(root, modules);
            sortModules();
        }

        private function sortModules():void
        {
            _modules.length = 0;
            for each(var module:IExtraModule in _moduleDict)
            {
                _modules.push(module);
            }

            var sortBehaver:Function = function (a:IExtraModule, b:IExtraModule):Number
            {
                if (a.weight < b.weight)
                    return 1;
                else if (a.weight > b.weight)
                    return -1;
                else
                    return 0;
            }
            _modules.sort(sortBehaver);
        }

        private function getModule():IExtraModule
        {
            var result:IExtraModule = null;
            for (var i:int = 0; i < _modules.length; i++)
            {
                if (_modules[i].canBeUsed())
                {
                    result = _modules[i];
                    break;
                }
            }
//            trace("get extra Module",getQualifiedClassName(result));
            return result;
        }

        public function get weight():int
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.weight;
            return -1;
        }

        public function getPath():String
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.getPath();
            return "";
        }

        public function canBeUsed():Boolean
        {
            if (getModule() != null)
                return true;
            return false;
        }

        public function getThisFormWidth():Number
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.getThisFormWidth();
            return 0;
        }

        public function getThisFormHeight():Number
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.getThisFormHeight();
            return 0;
        }

        public function fullScreen(isFullScreen:Boolean):void
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.fullScreen(isFullScreen);
        }

        public function get isFullScreen():Boolean
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.isFullScreen;
            return false;
        }

        public function folderExists(folderPath:String):Boolean
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.folderExists(folderPath);
            return false;
        }

        public function getFileList(filePath:String, fileType:String):Array
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.getFileList(filePath, fileType);
            return [];
        }

        public function prompt(message:String):void
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.prompt(message);
        }

        public function get type():String
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.type;
            return "";
        }

        public function setCallback(type:String, callback:Function):void
        {
            var module:IExtraModule = getModule();
            if (module != null)
                module.setCallback(type, callback);
        }

        public function hasCallback(type:String, callback:Function):Boolean
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.hasCallback(type, callback);
            return false;
        }

        public function removeCallback(type:String, callback:Function):void
        {
            var module:IExtraModule = getModule();
            if (module != null)
                module.removeCallback(type, callback);
        }

        public function executeCallback(type:String, data:Object):void
        {
            var module:IExtraModule = getModule();
            if (module != null)
                module.executeCallback(type, data);
        }

        public function exit():void
        {
            var module:IExtraModule = getModule();
            if (module != null)
                module.exit();
        }

        public function getCMDParams(cmdID:Number):String
        {
            var module:IExtraModule = getModule();
            if (module != null)
                return module.getCMDParams(cmdID);
            return "";
        }
    }
}
