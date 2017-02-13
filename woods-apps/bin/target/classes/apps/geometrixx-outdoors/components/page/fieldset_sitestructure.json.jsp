<%@page session="false"%>{
    collapsed: true,
    collapsible: true,
    title: "Site Structure",
    xtype: "dialogfieldset",
    items: [{
        fieldLabel: "Account Page",
        name: "./cq:accountPage",
        xtype: "pathfield"
    },{
        fieldLabel: "Signup Page",
        name: "./cq:signupPage",
        xtype: "pathfield"
    },{
        fieldLabel: "Shopping Cart Page",
        name: "./cq:cartPage",
        xtype: "pathfield"
    },{
        fieldLabel: "Smart List Page",
        name: "./cq:smartListPage",
        xtype: "pathfield"
    },{
        fieldLabel: "Private Messaging Mailbox Page",
        name: "./cq:mailboxPage",
        xtype: "pathfield"
    },{
        fieldLabel: "Checkout Page",
        name: "./cq:checkoutPage",
        xtype: "pathfield"
    },{
        fieldLabel: "Offline Page",
        fieldDescription: "This page is rendered when the underlying commerce service is offline.",
        name: "./cq:offlinePage",
        xtype: "pathfield"
    },{
        cls: "x-form-item-description",
        text: "Note: blank paths will inherit values from parent page(s).",
        xtype: "static"
    }]
}
