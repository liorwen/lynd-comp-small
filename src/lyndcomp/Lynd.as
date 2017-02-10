/**
 * Created by zear19st on 2017/2/6.
 */
package lyndcomp
{
    import flash.display.DisplayObjectContainer;

    import lyndcomp.component.AppComponent;
    import lyndcomp.services.extra.ExtraManager;
    import lyndcomp.services.extra.modules.DelphiExtraModule;
    import lyndcomp.services.extra.modules.IExtraModule;
    import lyndcomp.services.extra.modules.MdmExtraModule;
    import lyndcomp.services.loader.LoaderFactory;

    import lyndcomp.store.Store;
    import lyndcomp.tool.util;

    public class Lynd
    {
        private var _store:Store;
        private var _root:DisplayObjectContainer;
        private var _app:AppComponent;
        private var _loader:LoaderFactory;
        private var _extraManager:ExtraManager;

        public function Lynd(param:Object)
        {
            _store = new Store(param.store);
            _root = param.root;
            _loader = new LoaderFactory();
            _extraManager = new ExtraManager();
            _extraManager.register(_root, {
                mdm: {module: MdmExtraModule, weight: 99},
                delphi: {module: DelphiExtraModule, weight: 1}
            });
            createAppComponent(param);
        }

        public function get store():Store
        {
            return _store;
        }

        public function get root():DisplayObjectContainer
        {
            return _root;
        }

        public function createAppComponent(param:Object):void
        {
            if (!param.hasOwnProperty("component"))
                return;
            if (!util.hasExtendsClass(param.component, AppComponent))
                return;
            _app = new param["component"](this);
            _app.startup();
        }

        public function get loader():LoaderFactory
        {
            return _loader;
        }

        public function get extra():IExtraModule
        {
            return _extraManager;
        }
    }
}
