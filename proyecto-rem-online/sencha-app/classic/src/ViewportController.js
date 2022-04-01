Ext.define('HreRem.view.ViewportController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.mainviewport',  

    listen : {
        controller : {
            '#' : {
                unmatchedroute : 'onRouteChange'
            }
        }
    },

    routes: {
        ':node': 'onRouteChange'
    },
    

    onRouteChange:function(id){
        this.setCurrentView(id);
    },

    setCurrentView: function(hashTag) {
        hashTag = (hashTag || '').toLowerCase();
        var me = this,
        refs = me.getReferences(),
        mainCard = refs.mainCardPanel,
        mainLayout = mainCard.getLayout(),
        menuPrincipal = refs.menuPrincipal,
        storeTop = me.getView().menuTop,
        viewModel = me.getViewModel(),
        vmData = viewModel.getData(),
        store = menuPrincipal.getStore(),
        hashTag = (store.findNode('routeId',hashTag) || storeTop.findNode('routeId',hashTag)) ? hashTag : store.getAt(0).get('routeId'),//En caso de que el hashtag no esté en la lista, metemos el del primer elemento.
        node = store.findNode('routeId',hashTag),
        nodeTop = storeTop.findNode('routeId', hashTag),
        view = node ? node.get('view') : nodeTop ? nodeTop.get('view') : null,
        lastView = vmData.currentView,
        existingItem = mainCard.child('component[routeId=' + hashTag + ']'),
        newView;
        // Kill any previously routed window
        if (lastView && lastView.isWindow) {
            lastView.destroy();
        }

        lastView = mainLayout.getActiveItem();

        if (!existingItem) {

            newView = Ext.create('HreRem.view.' + (view || 'pages.Error404Window'), {
                    height: Ext.Element.getViewportHeight() - vmData.defaultHeaderHeight,
                    hideMode: 'offsets',
                    routeId: hashTag
                });
        }

        if (!newView || !newView.isWindow) {
            // !newView means we have an existing view, but if the newView isWindow
            // we don't add it to the card layout.
            if (existingItem) {
                // We don't have a newView, so activate the existing view.
                if (existingItem !== lastView) {
                    mainLayout.setActiveItem(existingItem);
                }
                newView = existingItem;
            }
            else {
                // newView is set (did not exist already), so add it and make it the
                // activeItem.
                Ext.suspendLayouts();
                mainLayout.setActiveItem(mainCard.add(newView));
                Ext.resumeLayouts(true);
            }
        }
		if(node != null){
			menuPrincipal.lastNode = node;
	        menuPrincipal.setSelection(node);
	        var totalP = store.getRootNode().childNodes.length;
			var botonTareas = me.getView().down("[reference=contadorTareas]");
			var botonAlertas = me.getView().down("[reference=contadorAlertas]");
			var botonAvisos = me.getView().down("[reference=contadorAvisos]");
			var botonFav = me.getView().down("[reference=btnFavoritos]");
			if(node.get("routeId") == "masivo"){
				for(var i=0; i<totalP; i++){
					if(store.getRootNode().childNodes[i].get("routeId") != "masivo"){
						var element = menuPrincipal.getViewModel().getView().getItem(store.getAt(i)).getToolElement();
						element.setVisibilityMode(Ext.dom.Element.DISPLAY);
						element.setVisible(false);
					}
				}
				if(!Ext.isEmpty(botonTareas)) botonTareas.hide();
				if(!Ext.isEmpty(botonAlertas)) botonAlertas.hide();
				if(!Ext.isEmpty(botonAvisos)) botonAvisos.hide();
				if(!Ext.isEmpty(botonFav)) botonFav.hide();
			}else {
				for(var i=0; i<totalP; i++){
					if(store.getRootNode().childNodes[i].get("routeId") != "masivo"){
						var element = menuPrincipal.getViewModel().getView().getItem(store.getAt(i)).getToolElement();
						element.setVisibilityMode(Ext.dom.Element.DISPLAY);
						element.setVisible(true);
					}					
				}
				if(!Ext.isEmpty(botonTareas)) botonTareas.show();
				if(!Ext.isEmpty(botonAlertas)) botonAlertas.show();
				if(!Ext.isEmpty(botonAvisos)) botonAvisos.show();
				if(!Ext.isEmpty(botonFav)) botonFav.show();
			}
		}

        if (newView.isFocusable(true)) {
            newView.focus();
        }

        vmData.currentView = newView;    
    },

//    setCurrentViewExt: function (hashTag, me){
//    	var me = me,
//        refs = me.getReferences(),
//        mainCard = refs.mainCardPanel,
//        mainLayout = mainCard.getLayout(),
//        menuPrincipal = refs.menuPrincipal,
//        menuTop = refs.menuTop,
//        viewModel = me.getViewModel(),
//        vmData = viewModel.getData(),
//        store = menuPrincipal.getStore(),
//        node = store.findNode('routeId', hashTag),
//        nodeTop = storeTop.findNode('routeId', hashTag),
//        view = node ? node.get('view') : nodeTop ? nodeTop.get('view') : null,
//        lastView = vmData.currentView,
//        existingItem = mainCard.child('component[routeId=' + hashTag + ']'),
//        newView;
//
//    // Kill any previously routed window
//    if (lastView && lastView.isWindow) {
//        lastView.destroy();
//    }
//
//    lastView = mainLayout.getActiveItem();
//
//    if (!existingItem) {
//
//        newView = Ext.create('HreRem.view.' + (view || 'pages.Error404Window'), {
//                height: Ext.Element.getViewportHeight() - vmData.defaultHeaderHeight,
//                hideMode: 'offsets',
//                routeId: hashTag
//            });
//    }
//
//    if (!newView || !newView.isWindow) {
//        // !newView means we have an existing view, but if the newView isWindow
//        // we don't add it to the card layout.
//        if (existingItem) {
//            // We don't have a newView, so activate the existing view.
//            if (existingItem !== lastView) {
//                mainLayout.setActiveItem(existingItem);
//            }
//            newView = existingItem;
//        }
//        else {
//            // newView is set (did not exist already), so add it and make it the
//            // activeItem.
//            Ext.suspendLayouts();
//            mainLayout.setActiveItem(mainCard.add(newView));
//            Ext.resumeLayouts(true);
//        }
//    }
//
//    menuPrincipal.setSelection(node);
//
//    if (newView.isFocusable(true)) {
//        newView.focus();
//    }
//
//    vmData.currentView = newView;    
//    },
    
    onMenuPrincipalSelectionChange: function (tree, node) {
    	
    	var me = this,    	
    	item = tree.getItem(node);  
        if (node && node.get('view')) {
			if(node.get("routeId") == "masivo"){
				if(tree.lastNode != null && tree.lastNode.get("routeId") != "masivo")
					me.fireEvent("errorToast", "Para acceder a este m&oacute;dulo dir&iacute;jase a REM Cargas Masivas");
				tree.setSelection(tree.lastNode);
			}else{
				this.redirectTo( node.get("routeId"));
			}
        }

    },

    onMainViewRender:function() {
    	var me = this,
	    viewModel = me.getViewModel(),
	    vmData = viewModel.getData(),
		hash = window.location.hash,
		id = hash.replace("#", "");
        this.redirectTo(id, true);        
    },

    onToggleNavigationSize: function (button) {
       var me = this,
       refs = me.getReferences(),
       menuPrincipal = refs.menuPrincipal,
       wrapContainer = refs.mainContainerWrap,
       collapsing = !navigationList.getMicro(),
       new_width = collapsing ? 75 : 150;
       
       if (Ext.isIE9m || !Ext.os.is.Desktop) {
            Ext.suspendLayouts();

            refs.icoLogo.setWidth(new_width);

            menuPrincipal.setWidth(new_width);
            menuPrincipal.setMicro(collapsing);

            Ext.resumeLayouts(); // do not flush the layout here...

            // No animation for IE9 or lower...
            wrapContainer.layout.animatePolicy = wrapContainer.layout.animate = null;
            wrapContainer.updateLayout();  // ... since this will flush them
        }
        else {
            if (!collapsing) {
                // If we are leaving micro mode (expanding), we do that first so that the
                // text of the items in the navlist will be revealed by the animation.
                menuPrincipal.setMicro(false);
                //button.setIconCls("x-fa fa-chevron-circle-left");
            }

            // Start this layout first since it does not require a layout
            refs.icoLogo.animate({dynamic: true, to: {width: new_width}});

            // Directly adjust the width config and then run the main wrap container layout
            // as the root layout (it and its chidren). This will cause the adjusted size to
            // be flushed to the element and animate to that new size.
            menuPrincipal.width = new_width;
            wrapContainer.updateLayout({isRoot: true});

            // We need to switch to micro mode on the navlist *after* the animation (this
            // allows the "sweep" to leave the item text in place until it is no longer
            // visible.
            if (collapsing) {
                menuPrincipal.on({
                    afterlayoutanimation: function () {
                        menuPrincipal.setMicro(true);
                    },
                    single: true
                });
                //button.setIconCls("x-fa fa-chevron-circle-right");
            }
        }
    },
    
        
    onClickMenuFavoritos: function(menuItem) {    	
		menuItem.up('menufavoritos').fireEvent("abrirfavorito"+menuItem.tipoId, menuItem.up('menufavoritos'), menuItem);
	},


	actualizarTareas: function(btn){
		var me = this;
		task = {
			    run: function() {
			      me.contadorTareas(btn);
			    },
			    interval: 1800000
			};

			Ext.TaskManager.start(task);
	},
	
	actualizarNotificaciones: function(btn){
		var me = this;
		task = {
			    run: function() {
			      me.contadorNotificaciones(btn);
			    },
			    interval: 1800000
			};

			Ext.TaskManager.start(task);
	},
	
	actualizarAlertas: function(btn){
		var me = this;
		task = {
			    run: function() {
			      me.contadorAlertas(btn);
			    },
			    interval: 1800000
			};

			Ext.TaskManager.start(task);
	},
	
	actualizarAvisos: function(btn){
		var me = this;
		task = {
			    run: function() {
			      me.contadorAvisos(btn);
			    },
			    interval: 1800000
			};

			Ext.TaskManager.start(task);
	},
	
	contadorTareas: function(btn){
		var url = $AC.getRemoteUrl('agenda/tareasPendientes');
		Ext.Ajax.request({
			url:url,
			success: function(response,opts){
				var texto = btn.getText();
				data = Ext.decode(response.responseText);
				btn.setText('Tareas (' + data.contador +')');
			},
			callback: function(options, success, response){
			}
	});
	},
	
//	contadorNotificaciones: function(btn){
//		var url = $AC.getRemoteUrl('agenda/notificacionesPendientes');
//		Ext.Ajax.request({
//			url:url,
//			success: function(response,opts){
//				var texto = btn.getText();
//				data = Ext.decode(response.responseText);
//				btn.setText('Notificaciones (' + data.contador +')');
//			},
//			callback: function(options, success, response){
//			}
//	});
//	},
	contadorAlertas: function(btn){
		var url = $AC.getRemoteUrl('agenda/alertasPendientes');
		Ext.Ajax.request({
			url:url,
			success: function(response,opts){
				var texto = btn.getText();
				data = Ext.decode(response.responseText);
				btn.setText('Alertas (' + data.contador +')');
			},
			callback: function(options, success, response){
			}
	});
	},
	contadorAvisos: function(btn){
		var url = $AC.getRemoteUrl('agenda/avisosPendientes');
		Ext.Ajax.request({
			url:url,
			success: function(response,opts){
				var texto = btn.getText();
				data = Ext.decode(response.responseText);
				btn.setText('Avisos (' + data.contador +')');
			},
			callback: function(options, success, response){
			}
	});
	},
	onClickBotonCerrarSesion: function(btn) {
		var me = this;
		
		Ext.Msg.show({
			   title: HreRem.i18n('title.cerrar.sesion'),
			   closable: false,
			   msg: HreRem.i18n('msg.desea.cerrar.sesion'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			           me.doLogout();
			        }
			   }
		});
	},
	
	doLogout: function() {
    	var urlLogout = $AC.getWebPath() + 'j_spring_security_logout';   	
        Ext.Ajax.request({
	        url : urlLogout,
	        success : function(response) {
	        		window.location = $AC.getWebPath() + 'js/logout_adfs.jsp';
	        }
        });
    }
	
});
