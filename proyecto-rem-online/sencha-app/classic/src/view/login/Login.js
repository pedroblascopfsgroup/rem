Ext.define('HreRem.view.login.Login', {
    extend: 'HreRem.view.common.WindowBase',
    xtype: 'loginwindow',
    requires: [
        'HreRem.view.login.LoginController'
    ],
    
    maximized: true,
    
    header: false,    
        
    controller: 'login',
    
    viewModel: {
        type: 'mainviewport'
    },

    closable: false,
    
    defaultFocus : 'j_username',
    
    cls: 'login',
    
    //layout: 'vbox',
    
    autoShow: true,
    
    initComponent: function() {
    	
    	var me = this;

    	me.items= [ 
    				
					{	        
			            xtype: 'toolbar',
			            padding: 0,
			            cls: 'logo-headerbar toolbar-btn-shadow',
			            bind: {
			            	height: '{defaultHeaderHeight}'
			            },
			            itemId: 'headerBar',
			            items: [
					            {
				                    xtype: 'tbtext',
				                    reference: 'icoLogoIzquierda',
				                    cls:'app-logo-login-izquierda'
				                },
				                {
				                    xtype: 'tbtext',
				                    cls:'app-version-login',
				                    html: $AC.getLabelVersion()
				            	}
		                ]
					},
					
					{
						xtype: 'container',
						layout: 'center',
						margin: '200 0 0 0',
						cls: 'login-container',
						items: [
						
									{
				    		 			xtype: 'form',
				    		 			cls: 'login-form shadow-panel',
				    		 			title: HreRem.i18n("title.window.login"),
				    		 			headerPadding: 10,
				    		 			bodyPadding: 10,
				    		 			width: 300,
				    		 			height: 180,
								        reference: 'formLogin',
								        url: $AC.getWebPath() + 'j_spring_security_check',
								        items: [{
										            xtype: 'textfield',
										            name: 'j_username',
										            fieldLabel: !Ext.isEmpty(HreRem.i18n) ? HreRem.i18n("fieldlabel.username") : "fieldlabel.username",
										            allowBlank: false,
										            enableKeyEvents: true,
										           	//style: {marginBottom: '10px !important'},
										            listeners: {
										                specialKey: 'onSpecialKey'
										            }
											     }, 
											     {
										            xtype: 'textfield',
										            name: 'j_password',
										            inputType: 'password',
										            fieldLabel: !Ext.isEmpty(HreRem.i18n) ? HreRem.i18n("fieldlabel.password") : "fieldlabel.password",
										            allowBlank: false,
										            enableKeyEvents: true,
										            cls: 'password',
										            listeners: {
										                specialKey: 'onSpecialKey'
										            }
				        						  }
				        				],
				        				
				        				buttons : [
				        							{
					        							text:     !Ext.isEmpty(HreRem.i18n) ? HreRem.i18n("btn.validar") : "btn.validar",
					        							listeners: {
					            									click: 'onLoginClick'
					        							}
				    								}
				    					]

    								}
						]
					}

    	];
    	
    	me.callParent();
    	
    }
	

});
