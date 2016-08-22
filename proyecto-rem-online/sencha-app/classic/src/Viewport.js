Ext.define('HreRem.view.Viewport', {
    extend: 'Ext.container.Viewport',
    xtype: 'mainviewport',

    requires: [
        'HreRem.MenuPrincipal', 'HreRem.ux.menu.MenuFavoritos',
        'HreRem.store.MenuPrincipalStore', 'HreRem.store.MenuTopStore',
		'HreRem.view.ViewportModel','HreRem.view.ViewportController',
		'Ext.Img'
        
    ],

    controller: 'mainviewport',

    viewModel: {
        type: 'mainviewport'
    },
	//layout: 'border',
	layout: {
        type: 'hbox',
        align: 'stretchmax'
    },
    listeners: {
        boxready: 'onMainViewRender'
    },
    
    userName: null,
    
    menuPrincipal: null,    
    menuTop: null,
    
    initComponent: function() {
    	
    	var me = this;   
		var menuFavoritos= Ext.create("HreRem.ux.menu.MenuFavoritos");
		
		/*var logo = Ext.create('Ext.Img', {
		    src: 'resources/images/logo.svg',
		    height: 75,
  			width: 100,
  			alt: 'logo',
		    floating: true,
		    margin: '0 0 0 0'
		}).showAt(0,0);*/
   	
    	me.items = [

		        {
		            xtype: 'container',
		            width: 60,
		            reference: 'mainContainerWrap',
		            layout: {
				        type: 'vbox',
				        align: 'stretchmax',
				
				        // Tell the layout to animate the x/width of the child items.
				        animate: true,
				        animatePolicy: {
				            x: true,
				            width: true
				        }
				    },

		            items: [
		            
		               	{
		                    xtype: 'menuprincipal',
		                    store: me.menuPrincipal
		               	}		                    
		            ],
		            
		           
		            beforeLayout : function() {
				        // We setup some minHeights dynamically to ensure we stretch to fill the height
				        // of the viewport minus the top toolbar
				        var me = this;

				        me.height = Ext.Element.getViewportHeight();
				        /*me.fireEvent("onBeforeLayoutMainContainerWrap");*/

			            // We use itemId/getComponent instead of "reference" because the initial
			            // layout occurs too early for the reference to be resolved
			            navTree = me.getComponent('menuPrincipal');
			
				        me.minHeight = me.height;
				
				        navTree.setStyle({
				            'min-height':   me.height + 'px'
				        });
		    		}
		        },
		        {
		        	xtype: 'container',
		        	//style: 'z-index: 1999',
		        	flex: 1,
		    	    layout: {
				        type: 'vbox',
				        align: 'stretch'
		    	    },
		    	    items: [
		    	    
			    	    {
			        	        
				            xtype: 'toolbar',
				            padding: '0 0 0 20',
				            cls: 'logo-headerbar toolbar-btn-shadow',
				            bind: {
				            	height: '{defaultHeaderHeight}'
				            },
				            itemId: 'headerBar',
				            items: [
				            {
				                    xtype: 'tbtext',
				                    reference: 'icoLogoIzquierda',
				                    cls:'app-logo-izquierda'
				            },
				            {
				                    xtype: 'tbtext',
				                    cls:'app-version',
				                    html: $AC.getLabelVersion()
				            },
				            { xtype: 'tbfill'   },
				            {
			                    cls: 'delete-focus-bg no-pointer',
			                    iconCls:'app-tb-ico ico-user',
			                    tooltip: 'Usuario identificado',
			                    text: me.userName		                    
			                    
			                },
			                {
			                    cls: 'delete-focus-bg',
			                    iconCls:'app-tb-ico ico-calendario-superior',
			                    href: '#agenda',
			                    reference: 'contadorTareas',
			                    hrefTarget: '_self',
			                    text: HreRem.i18n('btn.agenda'),
			                    listeners: {
		        					afterrender: 'actualizarTareas'
		        				},
		        				secFunPermToShow: 'MENU_TOP_TAREAS'
			                    //flex: 1
			                },
			                {
			                    cls: 'delete-focus-bg',
			                    iconCls:'app-tb-ico ico-alertas-top',
			                    href: '#alertas',
			                    reference: 'contadorAlertas',
			                    hrefTarget: '_self',
			                    text: HreRem.i18n('btn.alertas'),
			                    listeners: {
		        					afterrender: 'actualizarAlertas'
		        				},
		        				secFunPermToShow: 'MENU_TOP_ALERTAS'
			                				
			                },
			                {
			                    cls: 'delete-focus-bg',
			                    iconCls:'app-tb-ico ico-avisos',
			                    href: '#avisos',
			                    reference: 'contadorAvisos',
			                    hrefTarget: '_self',
			                    text: HreRem.i18n('btn.avisos'),
			                    listeners: {
		        					afterrender: 'actualizarAvisos'
		        				},
		        				secFunPermToShow: 'MENU_TOP_AVISOS'
			                    
			                },
			                			                
			                {
			                    cls: 'delete-focus-bg',
			                    iconCls:'app-tb-ico ico-favorito',
			                    text: HreRem.i18n('btn.favoritos'),
			                    //flex: 1,
			                    textAlign:'left',
			                    //width: '120px !important',
			                    //padding: '0px,20px,0px,0px',
								menu: menuFavoritos
			                },			                
			                {
			                    cls: 'delete-focus-bg',
			                    iconCls:'app-tb-ico ico-poweroff',
			                    text: HreRem.i18n('btn.cerrar.sesion'),
				                handler : 'onClickBotonCerrarSesion'

			                },
			                {
			                    xtype: 'tbtext',
			                    reference: 'icoLogoDerecha',
			                    cls:'app-logo-derecha'
			                }	                
						                
			            ]
			        },
			        {
			            xtype: 'container',	
			            margin: '0 0 0 10px',
			            reference: 'mainCardPanel',
			            scrollable: 'y',
			            flex: 1,
			            cls: 'right-main-container',
			            itemId: 'contentPanel',
			            layout: {
			                type: 'card',
			                anchor: '100%'
			            }
			        }
		    		]
		      	}

    	],
		
		me.callParent();
    	
    }

      
});  