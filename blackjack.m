classdef blackjack
    properties (SetAccess = 'public', GetAccess = 'public')
        %% Initializing Variables
        % A set of variables that will be used in the game
        % Status: finished
        remainingDeck; %Cell for the deck
        playerCards; %Treat as a cell array for each player
        dealerCards; %Treat as a cell array
        numPlayers;
        numDecks = 5; %Double
    end
    methods
        function trueFalse = checkAllBust(obj)
            %% Function to check if all players have busted
            % Goes through each fo the players to check
            % That not all of them have busted
            % Status: finished
            trueFalse = true;
            for i = 1:obj.numPlayers
                currPlayerSum = getCurrentSum(obj,i+1);
                if currPlayerSum < 21
                    trueFalse = false;
                end
            end
        end
        
        function result = checkWin(obj)
            %% Function to find the result of the game
            % Assuming you're player 1, this function 
            % resturns, as a char, the result of the game
            dealerSum = getCurrentSum(obj,1);
            playerSum = getCurrentSum(obj,2);
            if (playerSum <= 21 & playerSum > dealerSum)|(playerSum <= 21 & dealerSum > 21) 
                result = 'w';
            elseif playerSum <= 21 & playerSum == dealerSum
                result = 't';
            else
                result = 'l';
            end
        end
        
        function numCards = currentNumCards(obj,player)
            %% Function to get the current numer of cards player has
            % To counter empty padding, this function checks
            % exactly how many cards a given player has.
            % Status: finished
            playerCards = obj.playerCards;
            currentPlayerCards = [playerCards(player,:)];
            numCards = 0;
            for i = currentPlayerCards
                if ~isempty(i{1})
                    numCards = numCards + 1;
                end
            end
        end
        
        function obj = dealerPlay(obj)
            %% Simulate the dealer's moves
            % <17 = hit
            % >17 = stand
            % Status: finished
            summ = getCurrentSum(obj,1);
            allPlaysBust = checkAllBust(obj);
            if summ < 17 & ~allPlaysBust
                while summ < 17
                    obj = obj.hit(1);
                    summ = getCurrentSum(obj,1);
                end
            end
        end
        
        function cardSum = getCurrentSum(obj,player)
            %% Function to find the current sum of a players card
            % Goes into a player's hand and tallies their current count
            % Status: finished
            dealerCards = obj.dealerCards;
            playerCards = obj.playerCards;
            cardSum = 0;
            numAces = 0;
            if player == 1
                [rows,cols] = size(dealerCards);
                for i = 1:cols
                    currentCard = dealerCards{1,i};
                    if currentCard == 'A'
                        numAces = numAces + 1;
                    elseif ischar(currentCard)
                        cardSum = cardSum + 10;
                    else
                        cardSum = cardSum + currentCard;
                    end
                end
                if numAces > 0
                    for i = 1:numAces
                        if cardSum + 11 <= 21
                            cardSum = cardSum + 11;
                        else
                            cardSum = cardSum + 1;
                        end
                    end
                end
            else
                player = player - 1;
                playerCards = {playerCards{player,:}};
                cols = length(playerCards);
                for i = 1:cols
                    currentCard = playerCards{1,i};
                    if ~isempty(currentCard)
                        if currentCard == 'A'
                            numAces = numAces + 1;
                        elseif ischar(currentCard)
                            cardSum = cardSum + 10;
                        else
                            cardSum = cardSum + currentCard;
                        end
                    end
                end
                if numAces > 0
                    for i = 1:numAces
                        if cardSum + 11 <= 21
                            cardSum = cardSum + 11;
                        else
                            cardSum = cardSum + 1;
                        end
                    end
                end
            end
        end
        
        function obj = hit(obj,player)
            %% Function to let the player take a card
            % If the player, or dealer, would like to risk
            % taking another card to get closer to 21,
            % they are able to.
            % Status: finished
            dealerCards = obj.dealerCards;
            playerCards = obj.playerCards;
            remainingDeck = obj.remainingDeck;
            cardsToGet = floor(rand(1)*13)+1;
            summ = getCurrentSum(obj,player);
            if summ < 21
                if player == 1
                    while any([remainingDeck{2,cardsToGet}] == 0)
                        cardsToGet = floor(rand(1)*13)+1;
                    end
                    dealerCards = [dealerCards remainingDeck(1,cardsToGet)];
                    remainingDeck{2,cardsToGet} = remainingDeck{2,cardsToGet} - 1;
                    currentPlayerCards = dealerCards;
                else
                    player = player - 1;
                    numCards = currentNumCards(obj,player);
                    while any([remainingDeck{2,cardsToGet}] == 0)
                        cardsToGet = floor(rand(1)*13)+1;
                    end
                    playerCards(player,numCards+1) = remainingDeck(1,cardsToGet);
                    remainingDeck{2,cardsToGet} = remainingDeck{2,cardsToGet} - 1;
                    currentPlayerCards = {playerCards{player,1:numCards+1}};
                end
            end
            str = '';
            for i = currentPlayerCards
                str = [str num2str(i{1}) ' & '];
            end
            str(end-2:end) = [];
            updateSent = sprintf(['Your cards are: ' str '\n']);
            disp(updateSent);
            obj.dealerCards = dealerCards;
            obj.remainingDeck = remainingDeck;
            obj.playerCards = playerCards;
        end
        
        function obj = initialDeal(obj)
            %% Initial dealing of cards
            % Gives out the first two cards to each
            % of the players
            % Status: finished
            numCards = numRemainingCards(obj);
            numPlayers = obj.numPlayers;
            playerCards = obj.playerCards;
            dealerCards = obj.dealerCards;
            remainingDeck = obj.remainingDeck;
            if numCards < numPlayers*2 + 10
                obj.remainingDeck = obj.resetDeck();
            end
            
            cardsToGet = floor(rand(1,2*(numPlayers+1))*13)+1;
            counter = 1;
            while any([remainingDeck{2,cardsToGet}] == 0)
                cardsToGet = floor(rand(1,2*(numPlayers+1))*13)+1;
                counter = counter +1;
                if counter == 100
                    obj.remainingDeck = obj.resetDeck();
                    remainingDeck = obj.remainingDeck;
                end
            end
            
            dealerCards{1} = remainingDeck{1,cardsToGet(1)};
            dealerCards{2} = remainingDeck{1,cardsToGet(2)};
            remainingDeck{2,cardsToGet(1)} = remainingDeck{2,cardsToGet(1)} - 1;
            remainingDeck{2,cardsToGet(2)} = remainingDeck{2,cardsToGet(2)} - 1;
            for i = 1:numPlayers
                cardsToTakeOut = [cardsToGet(2+i) cardsToGet(3+i)];
                playerCards{i,1} = remainingDeck{1,cardsToTakeOut(1)};
                playerCards{i,2} = remainingDeck{1,cardsToTakeOut(2)};
                remainingDeck{2,cardsToTakeOut(1)} = remainingDeck{2,cardsToTakeOut(1)} - 1;
                remainingDeck{2,cardsToTakeOut(2)} = remainingDeck{2,cardsToTakeOut(2)} - 1;
            end
            
            obj.remainingDeck = remainingDeck;
            obj.dealerCards = dealerCards;
            obj.playerCards = playerCards;
        end
        
        function obj = initialReset(obj,numDecks)
            %% Function to be ran when creating the game
            % Sets the number of decks, resets the deck to
            % have the appropriate number of cards
            % and initializes all of the hands to empty.
            % Status: finished
            obj = obj.setNumDecks(numDecks);
            obj = obj.resetDeck();
            obj = obj.resetHands();
        end
        
        function numCards = numRemainingCards(obj)
            %% Counts the number of cards remaining in the deck
            % Status: finished
            countOfCards = obj.remainingDeck;
            countOfCards = [countOfCards{2,:}];
            numCards = sum(countOfCards);
        end
        
        function obj = otherPlayersMove(obj,player)
            %% Simulate the moves made by other players
            % Assumption: other players will move like the house
            % Status: finished
            summ = getCurrentSum(obj,player);
            while summ < 17
                obj = obj.hit(player);
                summ = getCurrentSum(obj,player);
            end
        end
        
        function obj = resetDeck(obj)
            %% Function to reset the deck
            % Uses the number of decks intended to work with and
            % resets the remaining deck accordingly.
            % Status: finished
            obj.remainingDeck = {'A',2,3,4,5,6,7,8,9,10,'J','Q','K';4,4,4,4,4,4,4,4,4,4,4,4,4};
            for i = 1:13
                obj.remainingDeck{2,i} = [obj.remainingDeck{2,i}].*obj.numDecks;
            end
        end
        
        function obj = resetHands(obj)
            %% Sets the hands to nothing
            % Status: finished
            obj.dealerCards = {[],[]};
            playersCell = {};
            for i = 1:obj.numPlayers
                playersCell{i,1} = [];
                playersCell{i,2} = [];
            end
            obj.playerCards = playersCell;
        end
        
        function obj = setNumDecks(obj,newNumDecks)
            %% A function to set the number of decks
            % Sets the number of decks that is
            % planned to be worked with.
            % Status: finished
            if nargin == 1
                newNumDecks = 5;
            end
            obj.numDecks = newNumDecks;
        end
        
        function obj = setNumPlayers(obj,numPlayers)
            %% Function to set the number of players playing at once
            % If there are multiple people playing at once,
            % (Which at a casino there probably are) this
            % will help to determine the accuracy of techniques.
            % Status: finished
            if nargin == 0
                numPlayers = 1;
            end
            obj.numPlayers = numPlayers;
        end
    end
end