using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using Vfp;

namespace VfpProj
{
    public static class AppMethods
    {
        #region Startup

        public static void App_Startup(object sender) // , StartupEventArgs e)
        {
            //App_StartupJumpList(sender, e);

            // version 2
            // App_StartupLoad2(Startup.Instance, e);
            //if (Startup.Instance.App != null 
            //    && FoxCmd.Attach())
            //    FoxCmd.AssignForm(window);
        }


        public static void Application_ThreadException(object sender, ThreadExceptionEventArgs args)
        {
            var ex = args.Exception;
            ex = ex.InnerException ?? ex;
            //if (CsApp.Instance.Window.FormObject != null)
            //    CsApp.Instance.Window.FormObject.LastError = ex;

            Startup.Instance.LastError = ex;

            Trace.Write(ex.Message);
        }


        public static object CreateFoxApp()
        {
            object app = null;
            try
            {
                // app = new VisualFoxpro.FoxApplication();
            }
            catch (InvalidCastException ex)
            {
                Startup.Instance.LastError = ex;
            }
            catch (InvalidComObjectException ex)
            {
                Startup.Instance.LastError = ex;
            }
            catch (COMException ex)
            {
                Startup.Instance.LastError = ex;
            }

            return app;
        }

        // public static void App_StartupJumpList(object sender, StartupEventArgs e)
            // JumpList jumpList1 = JumpList.GetJumpList(CsApp.Current);

        #endregion

        public static void App_DoCmd(string cmd)
        {
            var app = Startup.Instance.App;
            var DoCmd = app.GetType().GetMethod("DoCmd");
            DoCmd?.Invoke(app, new object[] { });
            // Startup.Instance.App.DoCmd(cmd, throwEx: false);
        }

        public static object App_DoEval(string expr)
        {
            var app = Startup.Instance.App;
            if (expr == "_VFP")
                return app;

            var Eval = app.GetType().GetMethod("Eval");
            if (app == null || expr.TrimEnd().Length == 0 || Eval == null)
                return null;

            var result = Eval?.Invoke(app, new object[] { expr });
            return result;
        }

        public static void WcfBind()
        {
            /*
            var service = VfpWcf.Instance;
            if (Host.Object != null)
                return;
            */
            //  Task.Factory.StartNew(() => Host.Create());
        }
    }
}
