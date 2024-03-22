function ShowOnboarding() {
    introJs().setOptions({
        steps: [{
            title: 'User Profile',
            intro: 'In this screen you can change your user information.'
        },
        {
            element: document.querySelector('#firstname_anchor'),
            intro: 'Change your First name.'
        },
        {
            element: document.querySelector('#lastname_anchor'),
            intro: 'Change your Last name.'
        },
        {
            element: document.querySelector('#email_anchor'),
            intro: 'Change you email address.'
        },
        {
            element: document.querySelector('#notification_anchor'),
            intro: 'Click the checkbox to receive automatic notifications. <br/><br/> <img src=\"../../Common/images/onboarding/check-notify.gif\" width=\"250px\" style=\"border: 1px solid #333;\" />',
            position: 'right'
        }, {
            title: 'User Profile',
            intro: 'Great, you just updated your profile.'
        }]
    }).start();
}
