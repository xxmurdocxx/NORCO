function Welcome() {
    introJs().setOptions({
        steps: [
            {
            element: document.querySelector('.welcome'),
                intro: '<video width=\"420\" height=\"240\" controls><source src=\"../../Common/video/Welcome.mp4\" type=\"video/mp4\">Your browser does not support the video tag.</video><p><img src=\"../../Common/images/icons/fullscreen.png\" /> Full View</p>'
            }      ]
    }).start();
}  
function DataUpload() {
    introJs().setOptions({
        steps: [
            {
                element: document.querySelector('.college-setup'),
                intro: '<p>Using information pulled from the <a href="https://coci2.ccctechcenter.org/" class="link-primary">COCI</a> website, MAP has already been pre-loaded with your college’s Course and Program Titles. However, other various data is still missing from your college\'s MAP database.Having the following information available to your MAP workflow members will allow for stronger and more easily validated course articulations.Please consider this as you perform the following actions.Remember, any configuration performed at this time can be revised at a later date.</p><br/><br/>'
            }]
    }).start();
}
function Workflow() {
    introJs().setOptions({
        steps: [
            {
                element: document.querySelector('.workflow-configuration'),
                intro: '<p>Every institution has the chance to configure their workflow according to the needs of their institution and their veteran population.</p><br/><br/>'
            },
            {
                element: document.querySelector('.workflow-noapprovalneeded'),
                intro: '<p>The option, "No Approval Needed" suggests that if an articulation sits within one stage for a certain number of days, the articulation will automatically be moved forward. If chosen, this option can be tailored by the number of days most convenient for your institution within the dropdown provided. Please be sure to select “Save Changes” if you choose to make any change at this time. Remember, any change(s) made at this time can be adjusted later by the MAP Ambassador.</p><br/><br/>'
            },
            {
                element: document.querySelector('.workflow-bypassstage'),
                intro: '<p>The required MAP workflow stages must include the roles of Evaluator and Implementation, so you may not select “Bypass Stage” for these roles. You may choose to bypass the Faculty and Articulation Officer stages. Bypassing a stage will remove that stage entirely in MAP.</p><br/><br/>'
            },
            {
                element: document.querySelector('.add-users'),
                intro: '<p>Click “Add Users” to add the contact information of the people assuming each role within your institution’s MAP workflow. If you are unsure of all members, simply add the contacts you are sure of at this time.<br/>If you choose to bypass this stage today, later we will show you how to configure your MAP workflow members within your user settings in the platform’s main navigation menu.</p><br/><br/>'
            },
            {
                element: document.querySelector('.VeteranLetter'),
                intro: '<p>Once a veteran is awarded units, your campus’ veteran’s specialist will be in charge of adjusting the other editable portions of this letter. Today, you will simply adjust your veteran representative and institution’s information. Watch the video to see how! </p><video width=\"420\" height=\"240\" controls><source src=\"../../Common/video/VeteranLetter.mp4?v=1\" type=\"video/mp4\">Your browser does not support the video tag.</video><p><img src=\"../../Common/images/icons/fullscreen.png\" /> Full View</p>'
            }]
    }).start();
}
function AdditionalInformation() {
    introJs().setOptions({
        steps: [
            {
                element: document.querySelector('.additional-information'),
                intro: '<p>Within this step you will revise the MAP contacts at your institution to help establish your official MAP team. Click the “?” symbol to view descriptions of each of these contacts. If you are unsure of any of these contacts within your institution, you may revisit this module at a later date.</p><br/><br/>'
            },
            {
            element: document.querySelector('.map-workflow'),
                intro: '<p>The MAP Workflow column is designed to capture information of those individuals who will be working within the Military Articulation Platform (MAP)</p><br/><br/>'
            },
            {
                element: document.querySelector('.veterans-resources'),
                intro: '<p>The Veterans Resources column should reflect all of the important contacts related to the veteran population at your campus.</p><br/><br/>',
                position:'left'
            },
            {
                element: document.querySelector('.institution-contacts'),
                intro: '<p>Finally, the Institution Contacts are those important bunch of people who will be useful to the campus’ awarding of credit for prior learning to those deserving veteran students. Keep in mind, if you are unsure of any of these contacts, you may leave fields blank.</p><br/><br/>'
            }  ]
    }).start();
}
function Resources() {
    introJs().setOptions({
        steps: [
            {
                element: document.querySelector('#imgSignUp1'),
                intro: 'To provide you with the best support, your MAP team has been provided with this Help Center Portal. To log in, simply click <a href="http://help.mappingarticulatedpathways.org/support/tickets/new" target="_blank" class="link-primary">this</a> link and click “SIGN UP WITH US”. You can also access the Help Portal through MAP in the horizontal navigation menu at the top of your MAP screen. Enter your name and professional email address.',
                position: 'top',
                scrollTo: 'tooltip'
            },
            {
                element: document.querySelector('#imgSignUp2'),
                intro: 'Check your email!',
                position: 'top',
                scrollTo: 'tooltip'
            },
            {
                element: document.querySelector('#imgSignUp3'),
                intro: 'Create your username and password for the portal. We recommend using the same login for MAP and saving your password on the site.',
                position: 'top',
                scrollTo: 'tooltip'
            },
            {
                element: document.querySelector('#imgSignUp4'),
                intro: 'You now have full access to the following support resources.',
                position: 'top',
                scrollTo: 'tooltip'
            },
            {
                element: document.querySelector('#imgSignUp5'),
                intro: 'Remember, these resources are always at your fingertips through the MAP horizontal navigation menu at the top of the home screen.',
                position: 'top',
                scrollTo: 'tooltip'
            }]
    }).start();
}