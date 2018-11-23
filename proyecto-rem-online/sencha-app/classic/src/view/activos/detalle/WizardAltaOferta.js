Ext.define('HreRem.view.activos.detalle.WizardAltaOferta', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'wizardaltaoferta',
    title		: 'Example Wizard',
    width		: 300,
    height		: 200,
    layout		: 'card',
    bodyStyle	: 'padding:15px',
    closable	: true,	
    defaults: {
        // applied to each contained panel
        border: true
    },
    // just an example of one possible navigation scheme, using buttons
    bbar: [
        {
            id: 'move-prev',
            text: 'Back',
            handler: function(btn) {
                navigate(btn.up("panel"), "prev");
            },
            disabled: true
        },
        '->', // greedy spacer so that the buttons are aligned to each side
        {
            id: 'move-next',
            text: 'Next',
            handler: function(btn) {
                navigate(btn.up("panel"), "next");
            }
        }
    ],
    // the panels (or "cards") within the layout
    items: [{
        id: 'card-0',
        html: '<h1>Welcome to the Wizard!</h1><p>Step 1 of 3</p>'
    },{
        id: 'card-1',
        html: '<p>Step 2 of 3</p>'
    },{
        id: 'card-2',
        html: '<h1>Congratulations!</h1><p>Step 3 of 3 - Complete</p>'
    }],
    renderTo: Ext.getBody()
});

var navigate = function(panel, direction){
    // This routine could contain business logic required to manage the navigation steps.
    // It would call setActiveItem as needed, manage navigation button state, handle any
    // branching logic that might be required, handle alternate actions like cancellation
    // or finalization, etc.  A complete wizard implementation could get pretty
    // sophisticated depending on the complexity required, and should probably be
    // done as a subclass of CardLayout in a real-world implementation.
    var layout = panel.getLayout();
    layout[direction]();
    Ext.getCmp('move-prev').setDisabled(!layout.getPrev());
    Ext.getCmp('move-next').setDisabled(!layout.getNext());
};