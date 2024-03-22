using System;
using Telerik.Web.UI;

namespace ems_app.UserControls
{
    public partial class DataUpdateChoice : System.Web.UI.UserControl
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlWarning.Visible = false;
            pnlSuccess.Visible = false;

            rauUploadFile.OnClientFileUploaded = "function(button, args){enableSubmitButton_" + this.ClientID + "(button, args, '" + btnSubmitUpload.ClientID + "');}";
            // set the async postback timeout to 60 minutes in case uploading the file takes a long time
            var rsm = (RadScriptManager)Page.Master.FindControl("RadScriptManager1");
            rsm.AsyncPostBackTimeout = 3600;
        }

        public event EventHandler FileUploaded;

        public string SampleFilePath
        {
            get
            {
                return lnkSampleFile.NavigateUrl;
            }
            set
            {
                lnkSampleFile.NavigateUrl = value;
            }
        }

        public string ErrorMessage
        {
            get
            {
                return lblErrorMessage.Text;
            }
            set
            {
                lblErrorMessage.Text = value;
                pnlError.Visible = true;
            }
        }

        public string WarningMessage
        {
            get
            {
                return lblWarningMessage.Text;
            }
            set
            {
                lblWarningMessage.Text = value;
                pnlWarning.Visible = true;
            }
        }

        public string SuccessMessage
        {
            get
            {
                return lblSuccessMessage.Text;
            }
            set
            {
                lblSuccessMessage.Text = value;
                pnlSuccess.Visible = true;
            }
        }

        public bool EditChoiceVisible
        {
            get
            {
                return radEdit.Visible;
            }
            set
            {
                radEdit.Visible = value;
            }
        }

        public bool DeleteAndReplaceWarning
        {
            get
            {
                return pnlDeleteAndReplaceWarning.Visible;
            }
            set
            {
                pnlDeleteAndReplaceWarning.Visible = value;
            }
        }

        protected void radEdit_CheckedChanged(object sender, EventArgs e)
        {
            pnlEdit.Visible = true;
            pnlUpload.Visible = false;
            pnlIntegration.Visible = false;
        }

        protected void radUpload_CheckedChanged(object sender, EventArgs e)
        {
            pnlEdit.Visible = false;
            pnlUpload.Visible = true;
            pnlIntegration.Visible = false;
        }

        protected void radIntegration_CheckedChanged(object sender, EventArgs e)
        {
            pnlEdit.Visible = false;
            pnlUpload.Visible = false;
            pnlIntegration.Visible = true;
        }

        protected void rauUploadFile_FileUploaded(object sender, Telerik.Web.UI.FileUploadedEventArgs e)
        {
            var rauUploadFile = (RadAsyncUpload)sender;
            if (rauUploadFile.UploadedFiles.Count == 0)
            {
                this.ErrorMessage = "No file was uploaded, please try again";
                return;
            }

            FileUploaded(sender, e);
        }
    }
}