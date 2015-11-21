using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;


namespace MyControl
{
    // [COMVisible(true)]
    public class MyControl : AxHost
    {
        public MyControl()
            : base("121C3E0E-DC6E-45dc-952B-A6617F0FAA32")
                // "5747094E-84FB-47B4-BC0C-F89FB583895F")
        {
            //DllLoad();

            // Open the CLSID\{guid}
            //Kosmala.Michal.ActiveXTest.ActiveXObject.RegisterClass2(
            //     "HKEY_CLASSES_ROOT\\ADendrite.OurActiveX"); // CLSID\\{121C3E0E-DC6E-45dc-952B-A6617F0FAA32}");
        }

        //[DllImport("MyActiveX.dll", SetLastError = true)]
        //public static extern Int32 DllLoad();

        public void Run()
        {
            dynamic ax = GetOcx();
            ax.Run();
        }

        public void Stop()
        {
            dynamic ax = GetOcx();
            ax.Stop();
        }
    }

    public static class Program
    {
        //[STAThread]
        //static void Main2()
        //{
        //    Application.EnableVisualStyles();

        //    Form f = new Form();
        //    AddControl(f);

        //    f.ShowDialog();
        //}

        public static void AddControl(this Form f)
        {
            f.Text = "My control";
            f.StartPosition = FormStartPosition.CenterScreen;
            f.Width = 640;
            f.Height = 480;

            MyControl c = new MyControl();
            c.Dock = DockStyle.Fill;
            c.BeginInit();

            Button b = new Button();            
            b.Dock = DockStyle.Top;
            b.Text = "Run/Stop";

            bool running = false;
            b.Click += (s, e) =>
            {
                if (running)
                {
                    c.Stop();
                    running = false;
                }
                else
                {
                    c.Run();
                    running = true;
                }
            };

            f.Controls.Add(b);
            f.Controls.Add(c);
            
        }
    }
}

