using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Telerik.Web.UI;

namespace ems_app
{
    public class GenericControls
    {
        public static string GetSelectedItemText(RadListBox controlID)
        {
            RadListBox listBox = (RadListBox)controlID;
            string[] checkedItems = new string[100];
            if (listBox != null)
            {
                for (int idx = 0; idx < listBox.Items.Count; idx++)
                {
                    if (listBox.Items[idx].Checked == true)
                    {
                        checkedItems[idx] = listBox.Items[idx].Value;
                    }

                }
            }
            return string.Join(",", checkedItems.Where(x => !string.IsNullOrEmpty(x)).ToArray());
        }
        public static void SetSelectedItem(RadListBox controlID, string text)
        {
            RadListBox listBox = (RadListBox)controlID;
            string[] selectedValues = text.Split(',');
            foreach (string selectedValue in selectedValues)
            {
                for (int idx1 = 0; idx1 < listBox.Items.Count; idx1++)
                {
                    RadListBoxItem li = listBox.Items[idx1];
                    if (li.Value.Equals(selectedValue))
                    {
                        li.Checked = true;
                    }
                }
            }
        }
    }
}