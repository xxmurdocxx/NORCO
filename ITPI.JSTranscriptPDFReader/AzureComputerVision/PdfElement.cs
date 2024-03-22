using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ITPI.JSTranscriptPDFReader.AzureComputerVision
{
    public class PdfElement
    {
        //leftPos = Convert.ToDouble(line.BoundingBox[0]);
        //                    yAxis = Convert.ToDouble(line.BoundingBox[1]);
        //                    width = Convert.ToDouble(line.BoundingBox[2]) - Convert.ToDouble(line.BoundingBox[0]);
        //                    height = Convert.ToDouble(line.BoundingBox[7]) - Convert.ToDouble(line.BoundingBox[1]);

        public IList<double?> BoundingBox { get; set; }

        public double LeftPosition
        {
            get { return (double) this.BoundingBox[0]; }
        }
        public double TopPosition
        {
            get { return (double) this.BoundingBox[1]; }
        }

        public double Height
        {
            get { return Convert.ToDouble(this.BoundingBox[7]) - Convert.ToDouble(this.BoundingBox[1]); }
        }

        public double Width
        {
            get { return Convert.ToDouble(this.BoundingBox[2]) - Convert.ToDouble(this.BoundingBox[0]); }
        }
        public string PdfText { get; set; }

        public PdfElement(IList<double?> box, string pdfTxt)
        {
            this.BoundingBox = box;
            this.PdfText = pdfTxt;
        }
    }
}
