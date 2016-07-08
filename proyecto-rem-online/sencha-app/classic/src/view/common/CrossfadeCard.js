Ext.define('HreRem.view.common.CrossfadeCard', {
    extend: 'Ext.layout.container.Card',
    
    alias: 'layout.crossfadecard',

	setActiveItem: function (newCard) {
			var me = this,
				owner = me.owner,
				oldCard = me.activeItem,
				rendered = owner.rendered,
				newIndex;


			newCard = me.parseActiveItem(newCard);
			newIndex = owner.items.indexOf(newCard);


			// If the card is not a child of the owner, then add it.
			// Without doing a layout!
			if (newIndex === -1) {
				newIndex = owner.items.items.length;
				Ext.suspendLayouts();
				newCard = owner.add(newCard);
				Ext.resumeLayouts();
			}


			// Is this a valid, different card?
			if (newCard && oldCard !== newCard) {
				// Fire the beforeactivate and beforedeactivate events on the cards
				if (newCard.fireEvent('beforeactivate', newCard, oldCard) === false) {
					return false;
				}
				if (oldCard && oldCard.fireEvent('beforedeactivate', oldCard, newCard) === false) {
					return false;
				}


				if (rendered) {
					Ext.suspendLayouts();


					// If the card has not been rendered yet, now is the time to do so.
					if (!newCard.rendered) {
						me.renderItem(newCard, me.getRenderTarget(), owner.items.length);
					}


					var handleNewCard = function () {
						// Make sure the new card is shown
						if (newCard.hidden) {
							newCard.show();
						}


						if (!newCard.tab) {
							var newCardEl = newCard.getEl();
							newCardEl.dom.style.opacity = 1;
							if (newCardEl.isStyle('display', 'none')) {
								newCardEl.setDisplayed('');
							} else {
								newCardEl.show();
							}
						}


						// Layout needs activeItem to be correct, so set it if the show has not been vetoed
						if (!newCard.hidden) {
							me.activeItem = newCard;
						}
						Ext.resumeLayouts(true);
					};


					var handleOldCard = function () {
						if (me.hideInactive) {
							oldCard.hide();
							oldCard.hiddenByLayout = true;
						}
						oldCard.fireEvent('deactivate', oldCard, newCard);
					};


					if (oldCard && !newCard.tab) {
						var oldCardEl = oldCard.getEl();
						oldCardEl.fadeOut({
							callback: function () {
								handleOldCard();
								handleNewCard();
							}
						});


					} else if (oldCard) {
						handleOldCard();
						handleNewCard();
					} else {
						handleNewCard();
					}


				} else {
					me.activeItem = newCard;
				}


				newCard.fireEvent('activate', newCard, oldCard);


				return me.activeItem;
			}
			return false;
	}
});