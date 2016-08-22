Ext.define('HreRem.view.activos.ComingSoon', {
    extend: 'Ext.form.Panel',
    xtype: 'comingsoon', 
   	items: [
   			{
        		xtype:'fieldset',
        		border: false,
				collapsible: false,
				collapsed: false,
			    layout: {
			        type: 'hbox',
			        align: 'stretch'
			    },
				title: 'Funcionalidad no desarrollada',				
				items: [
							
					{
						
						xtype: 'container',
						flex: 1,
						items: [
								{
								
									xtype:'image',
									src: 'resources/images/comingsoon.png',
								    width: '184',
									height: '90',
									alt: 'Funcionalidad no desarrollada'
								}						
						]
					}
					
							
						
				]
   			}
    ]
    
});