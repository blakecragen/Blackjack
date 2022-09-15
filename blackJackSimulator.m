clc;
s = 's';
h = 'h';
e = 'e';
numDecks = input('Enter Number of Decks: ');
deck = {'A',2,3,4,5,6,7,8,9,10,'J','Q','K';4,4,4,4,4,4,4,4,4,4,4,4,4};
fullDeck = deck;
for i = 1:13
    fullDeck{2,i} = [fullDeck{2,i}].*numDecks;
end
while sum([fullDeck{2,:}]) > 0
    cardsToGet = floor(rand(1,4)*13)+1;
    dealerCards = [];
    playerCards = [];
    for i = cardsToGet
        fullDeck{2,i} = [fullDeck{2,i}] - 1;
    end
    while isempty(dealerCards) | isempty(playerCards)
        if any([fullDeck{2,cardsToGet}] == 0)
            cardsToGet = floor(rand(1,4)*13)+1;
        else
            dealerCards = [fullDeck(1,cardsToGet([1,2]))];
            playerCards = [fullDeck(1,cardsToGet([3,4]))];
        end
    end
    disp(['Dealer Card: ' num2str(dealerCards{1})]);
    disp(['Player Cards: ' num2str(playerCards{1}) ' & ' num2str(playerCards{2})]);
    dec = input('Hit or Stand: ');
    playerCardLen = 2;
    while strcmpi(dec,'h')
        cardsToGet = floor(rand()*13)+1;
        while length(playerCards) == playerCardLen;
            if any([fullDeck{2,cardsToGet}] == 0)
                cardsToGet = floor(rand(1)*13)+1;
            else
                playerCards = [playerCards fullDeck(1,cardsToGet)];
            end
        end
        str = '';
        for i = 1:length(playerCards)
            str = [str num2str(playerCards{i}) ' & '];
        end
        str(end-2:end) = [];
        disp(['Player Cards: ' str]);
        playerSum = findSum(playerCards);
        if playerSum < 21
            disp(['Your sum: ' num2str(playerSum)]);
            dec = input('Hit or Stand: ');
            playerCardLen = playerCardLen + 1;
        elseif playerSum == 21
            dec = 's';
        else
            disp('You busted');
            dec = 's';
        end
    end
    dealerSum = findSum(dealerCards);
    notBust = true;
    while dealerSum < 17 && notBust && playerSum <= 21
        lenDealCards = length(dealerCards);
        cardsToGet = floor(rand(1)*13)+1;
        while length(dealerCards) == lenDealCards;
            if any([fullDeck{2,cardsToGet}] == 0)
                cardsToGet = floor(rand(1)*13)+1;
            else
                dealerCards = [dealerCards fullDeck(1,cardsToGet)];
            end
        end
        dealerSum = findSum(dealerCards);
        if dealerSum > 21
            notBust = false;
        end
    end
    
    str = '';
    for i = 1:length(playerCards)
        str = [str num2str(playerCards{i}) ' & '];
    end
    str(end-2:end) = [];
    str2 = '';
    for i = 1:length(dealerCards)
        str2 = [str2 num2str(dealerCards{i}) ' & '];
    end
    str2(end-2:end) = [];
    disp('');
    disp(['Player Cards: ' str]);
    disp(['Dealer Cards: ' str2]);
    disp('');
    playerSum = findSum(playerCards);
    dealerSum = findSum(dealerCards);
    if (playerSum > dealerSum && playerSum <= 21) | ~notBust
        disp('You win!');
    elseif dealerSum == playerSum
        disp('Tie!');
    else
        disp('You lose :(');
    end
    dec = input('Play Again (s) or end (e)?');
    clc;
    if strcmp(dec,'e')
        break
    end
end

function playerSum = findSum(playerCards)
playerSum = 0;
numAces = 0;
for i = playerCards
    switch i{1}
        case 'A'
            numAces = numAces + 1;
        case {'J','Q','K'}
            playerSum = playerSum + 10;
        otherwise
            playerSum = playerSum + i{1};
    end
end
for i = 1:numAces
    if playerSum + 11 <= 21
        playerSum = playerSum + 11;
    else
        playerSum = playerSum + 1;
    end
end
end





