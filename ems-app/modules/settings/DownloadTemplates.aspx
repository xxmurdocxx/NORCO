<%@ Page Title="" Language="C#" MasterPageFile="~/Common/templates/main.Master" AutoEventWireup="true" CodeBehind="DownloadTemplates.aspx.cs" Inherits="ems_app.modules.settings.DownloadTemplates" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStyles" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <p class="h2">Download Templates</p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<h3><a href="docs/Course.csv">College Curriculum - Course Data elements – Course.csv</a></h3>
<ul>
    <li>A.	College Abbreviation</li>
    <li>B.	Course Discipline Code (i.e. BUS)</li>
    <li>C.	Course Discipline Name (i.e. BUSINESS)	</li>
    <li>D.	Course Number (i.e. 20)</li>
    <li>E.	Course ID (CID if available)</li>
    <li>F.	Course Title</li>
    <li>G.	Course Catalog Description</li>
    <li>H.	Minimum Units (i.e. 1.5)</li>
    <li>I.	Maximum Units (i.e. 3.0)</li>
</ul>
<p>Note: (If it is not a variable unit course these values are the same)</p>
<H3><a href="docs/SLO.csv">Student Learning Outcomes – SLO.csv</a></H3>
    <ul>
        <li>A.	Course Discipline Code (i.e. BUS)</li>
        <li>B.	Course Number (i.e. 20)</li>
        <li>C.	SLO Number</li>
        <li>D.	SLO Description</li>
    </ul>
<h3><a href="docs/POS.csv">Program of Study – POS.csv</a></h3>
<ul>
    <li>A.	Program Title</li>
    <li>B.	Academic Program ID (if available)</li>
    <li>C.	School (if available)</li>
    <li>D.	Department (if available)</li>
    <li>E.	CIP CODE (Classification of Instructional Programs, if available)</li>
    <li>F.	SOC CODE (if available)</li>
    <li>G.	TOP CODE (Taxonomy of Programs, if available)</li>
    <li>H.	Program Type (i.e. AA Degree, AS Degree, Certificate of Achievement)</li>
    <li>I.	Program of Study Total Units</li>
</ul>
<h3><a href="docs/POG_REQ_CRSE.csv">Program Required Courses (i.e. ACC 1A, BUS 10, BUS 20, etc.) PROG_REQ_CRSE.CSV</a></h3>
<ul>
    <li>J.	Program Title</li>
    <li>K.	Academic Program ID (if available)</li>
    <li>L.	Required Courses Major Group </li>
    <li>M.	Required Courses Minor Group (if available)</li>
    <li>N.	Course Discipline Code (i.e. BUS)</li>
    <li>O.	Course Number (i.e. 20)</li>
</ul>
<h3><a href="docs/POG_REQ_ELEC_CRSE.csv">Program Restrictive Elective Courses (i.e. ACC 1A, BUS 10, BUS 20, etc.) PROG_REQ_ELEC_CRSE.CSV</a></h3>
<ul>
    <li>P.	Program Title</li>
    <li>Q.	Academic Program ID (if available)</li>
    <li>R.	Required Courses Major Group</li>
    <li>S.	Required Courses Minor Group (if available)</li>
    <li>T.	Course Discipline Code (i.e. BUS)</li>
    <li>U.	Course Number (i.e. 20)</li>
</ul>
<h3><a href="docs/PLO.csv">Program Learning Outcomes  - PLO.csv</a></h3>

<P>College Organizational Structure (Optional. College Taxonomy if available)</P>
<P>Relationship between Course Discipline, Department and School (if available)</P>
<p>(i.e. BUS-Business/Business Engineering & Information Technology/School of Business and Management)</p>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
