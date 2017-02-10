/**
 * Created by zear19st on 2016/12/16.
 */
package lyndcomp.services.extra
{
    import flash.utils.Dictionary;

    import lyndcomp.services.extra.modules.IExtraModule;
    import lyndcomp.tool.util;

    public class ExtraFactory implements IExtraFactory
    {
        protected var _moduleDict:Dictionary;

        public function ExtraFactory()
        {
            _moduleDict = new Dictionary();
        }

        public function register(root:*, modules:Object):void
        {
            for (var name:String in modules)
            {
                if (util.hasInterface(modules[name].module, IExtraModule))
                {
                    _moduleDict[name] = new modules[name].module(name, root,  modules[name].weight);
                }
            }
        }


        public function getExtra(type:String):IExtraModule
        {
            return _moduleDict[type];
        }

    }
}
