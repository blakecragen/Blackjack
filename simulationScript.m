numPlayers = 5;
numDecks = 4;
order = randOrdGenerator(numPlayers);
order = [(order+1) 1];
mitCardCounter = 0;
numHands = 10;
money = 100;
bet = 5;
numWins = 0;
handsForReset = floor(4*numDecks/numPlayers);

%% Game setup
myGame = blackjack;
myGame = myGame.initialReset(numDecks);
currHand = 1
while  currHand <= numHands & money > 0
    myGame = myGame.setNumPlayers(numPlayers);
    myGame = myGame.initialDeal();
    for i = order
        myGame = myGame.otherPlayersMove(i);
    end
    gameRes = myGame.checkWin();
    switch gameRes
        case 'w'
            money = money + bet;
            numWins = numWins + 1;
        case 'l'
            money = money - bet;
    end
    
    dealerCards = myGame.dealerCards;
    for i = dealerCards
        i = i{1};
        if ischar(i) | i == 10
            mitCardCounter = mitCardCounter - 1;
        elseif i < 8
            mitCardCounter = mitCardCounter + 1;
        end
    end
    playersCards = myGame.playerCards;
    [r,c] = size(playersCards);
    for i = 1:r
        curPlayerCard = [playersCards(i,:)];
        for j = 1:c
            if ischar(i) | i == 10
                mitCardCounter = mitCardCounter - 1;
            elseif i < 6
                mitCardCounter = mitCardCounter + 1;
            end
        end
    end
    currHand = currHand + 1;
    if mod(currHand,handsForReset) == 0
        mitCardCounter = 0;
    end
end
handsPlayed = currHand - 1;




%% Functions to determine order of players
% Your order is not guaranteed in a casino, so
% this is meant to determine a random order
function order = randOrdGenerator(numPlayers)
order = ones(1,numPlayers);
if numPlayers > 1
    repeats = checkForRepeats(order);
    while repeats
        order = floor(rand(1,numPlayers)*numPlayers) + 1;
        repeats = checkForRepeats(order);
    end
end
end
function repeats = checkForRepeats(order)
repeats = false;
for i = order
    mask = order == i;
    if sum(mask) > 1
        repeats = true;
    end
end
end



