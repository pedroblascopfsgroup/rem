/**
 * This View Controller is associated with the Login view.
 */
Ext.define('HreRem.view.login.LoginController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.login',
    
    init: function() {
    	var me = this;
    	
    	if(!Ext.isEmpty(HreRem.i18n)) {
    		me.logginText= HreRem.i18n('msg.mask.espere');
    	}
    	
    },

    
    onSpecialKey: function(field, e) {
        if (e.getKey() === e.ENTER) {
            this.doLogin();
        }
    },
    
    onLoginClick: function() {
        this.doLogin();
    },
    
    doLogin: function() {
        
        var me = this,
        formLogin = this.lookupReference('formLogin');        
        if (formLogin.isValid()) {
        	formLogin.up('window').hide();

            Ext.getBody().mask(me.logginText);

			formLogin.submit({				
                success: function(form, action) {                	
                   	formLogin.up('window').fireEvent("loginsuccesful");	
                   	Ext.getBody().unmask();
                },
                failure: function(form, action) {
                	formLogin.up('window').fireEvent("loginfailure");	
                	Ext.getBody().unmask();
                }
            });
        }
    }    

});
