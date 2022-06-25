%%%%%%%%%%%%%%%%%%%%%%%%
%algorithmChanceRedux
%Eamon Gekakis
%Rev 1 - 7/17/21
%Rev 2 - 6/25/22
%For Album Club Redux
%%%%%%%%%%%%%%%%%%%%%%%%
clear 
close all
clc
format longG
tic
load albumClubMembers.mat
[randNum] = randomizer();
[seed] = whileLooper(albumClubMembers,randNum);
rng(seed,'twister');
[pickingOrder] = matchNsift(albumClubMembers);
toc

function [seed] = randomSeedGenerator(albumClubMembers)
randomNumberGenerator = rng('shuffle','threefry'); %setting the random number generator to a Threefry 4x64 generator with 20 rounds seeded at current time (10 digit time expression)
timeSeed = randomNumberGenerator.Seed; %storing the time-based seed value
randomSeedGen = rand(length(albumClubMembers)); %randomizing a matrix with the Threefry rng based on the size of the album club member list
randomSeedGen = sum(randomSeedGen); %summing the elements in each column of the matrix 
maxVal = round(max(randomSeedGen)*10000); %finding the max value of the matrix and normalizing to match 10 digit time expression
minVal = round(min(randomSeedGen)*10000); %finding the min value of the matrix and normalizing to match 10 digit time expression 
comb = str2double(sprintf('%d', maxVal, minVal)); %creating a 10 digit double from the normalized max and min values 
timeSeed = dec2base(timeSeed,10) - '0'; %splitting the time seed into individual integers 
comb = dec2base(comb,10) - '0'; %splitting the combined max and min into individual integers 
seed = max(sum(comb),sum(timeSeed)); %defining the seed as the greater value between the sum of the combined max and min value and the time seed value 
seed = ((randn*seed)/randn); %normalizing seed value with other random numbers
end

function [seed] = seedSpice(seed)
seed = num2str(seed); %turning the seed into a string
i = strfind(seed,'.'); %finding where the decimal point is 
seed = cellstr(seed')'; %converting to a cell from a string
seed(i) = []; %indexing and removing the decimal point
seed = str2double(cell2mat(seed)); %converting to a number 
end

function [randNum] = randomizer()
count = 0; %setting a while counter
error_count = 0; %setting an error counter
while count == error_count %repeat while loop until function runs, then break on successful run
    try
        randomNumberGenerator = rng('shuffle'); %define a default rng with shuffled seed
        randNum = randi((rand^3)*(randn^3)*(randomNumberGenerator.Seed/100000)); %random number generated by default rng with shuffled seed to size seedMat
    catch ME
        error_count = error_count + 1; %increment error counter
    end
    count = count + 1; %increment counter
end
end

function [seed] = whileLooper(albumClubMembers,randNum)
seedMat = zeros(randNum,1); %preallocate size of seedMat
ii = 1; %initiate while counter
while ii < randNum %repeat for a random amount of time
seed = randomSeedGenerator(albumClubMembers); %call randomized seed value
    while seed < 0 %idk what this does I added it early and forget
        seed = randomSeedGenerator(albumClubMembers); %' ' 
    end    
seedMat(ii) = seedSpice(seed); %fills seedMat with a different seed value for the randNum while length
ii = ii+1; %increments while counter
end
seed = round(mean(seedMat)); %creates seed from average of all seeds in seedMat
end

function [pickingOrder] = matchNsift(albumClubMembers)
albumClubMembers(:,2) = num2cell(rand(length(albumClubMembers),1)); %now with the randomized seed, rand is used to generate random values
pickingOrder = sortrows(albumClubMembers,2,'descend'); %sorts by highest values matched to name
disp(pickingOrder) %displays results
end