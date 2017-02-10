/**
 * Created by zear19st on 2016/12/16.
 */
package lyndcomp.services.loader.modules
{
    import flash.display.LoaderInfo;
    import flash.utils.Dictionary;

    public class ComponentLoaderModule extends LoaderModule
    {
        public function ComponentLoaderModule(type:String)
        {
            super(type);
        }

        override public function isLoaded(loadedDict:Dictionary, path:String, config:Object):Boolean
        {
            var check:Boolean = true;
            for (var key:String in config.components)
            {
                if (loadedDict[getKey(path, config, key)] == null)
                {
                    check = false;
                    break;
                }
            }
            return check;

        }

        override public function getPath(path:String, config:Object):String
        {
            return path + config.file;
        }


        override public function getKey(path:String, config:Object, option:String):String
        {
            return type + "_" + getPath(path, config) + "_" + option;
        }

        override public function loaded(loadedDict:Dictionary, path:String, config:Object, loaderInfo:LoaderInfo):*
        {
            var resultClass:Dictionary = new Dictionary();
            for (var key:String in config.components)
            {
                resultClass[key] = loaderInfo.applicationDomain.getDefinition(config.components[key]) as Class;
                loadedDict[getKey(path, config, key)] = resultClass[key];
            }
            return resultClass;
        }


        override public function getLoaded(loadedDict:Dictionary, path:String, config:Object):*
        {
            var resultClass:Dictionary = new Dictionary();
            for (var key:String in config.components)
            {
                resultClass[key] = loadedDict[getKey(path, config, key)];
            }
            return resultClass;

        }
    }
}
