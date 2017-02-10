/**
 * Created by zear19st on 2016/12/16.
 */
package lyndcomp.services.loader.modules
{
    import flash.display.LoaderInfo;
    import flash.utils.Dictionary;

    public interface ILoaderModule
    {
        function isLoaded(loadedDict:Dictionary, path:String, config:Object):Boolean;

        function getPath(path:String, config:Object):String;

        function loaded(loadedDict:Dictionary, path:String, config:Object, loaderInfo:LoaderInfo):*;

        function getLoaded(loadedDict:Dictionary, path:String, config:Object):*;
    }
}
