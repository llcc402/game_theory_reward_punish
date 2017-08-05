

N = 40;
r = 0.4;
T = 1 + r; R = 1; P = 0; S = 0;
K = 0.1; % the param in Femi
K1 = 0.9; % the weight for contribution
neigRadius = 1;
iter_num = 300;

punish_prob = 0.1; % punish the bottom 10% players who contributes the least
reward_prob = 1 - punish_prob; % reward the top 10% players who contribute the most
punish_per_player = 0.05; % how much we punish each player whose contribution is smaller than punish_spot

% 初始化策略矩阵
StrasMatrix = initStrasMatrix( N );
figure(1)
DrawStraMatrix(StrasMatrix)
title('Initial StrasMatrix')
pause(0.01)


% 博弈支付矩阵
PayoffMatr = [R, S; T, P];

% 邻居间博弈矩阵
PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );

CumPaysMat = zeros(N);

% accept
accept_rate = zeros(1, iter_num);

fq_coop = zeros(1, iter_num);

for i = 1:iter_num
    tic
    
    contributMat = Contribution(PaysMatrix, N, neigRadius);
    spots = quantile(contributMat(:), [punish_prob, reward_prob]);
    punish_ix = find(contributMat < spots(1));
    reward_ix = find(contributMat > spots(2));
    
    reward_pays = punish_per_player * length(punish_ix);
    reward_per_player = reward_pays / length(reward_ix);
    
    PaysMatrix(punish_ix) = PaysMatrix(punish_ix) - punish_per_player;
    PaysMatrix(reward_ix) = PaysMatrix(reward_ix) + reward_per_player;
    
    [StrasMatrix, accept_rate(i)] = Evolution( StrasMatrix, PaysMatrix, ...
        neigRadius, K, K1);  % 一次演化，更新各节点的策略
    
    PaysMatrix = Play( StrasMatrix, PayoffMatr, neigRadius );
    
    fq_coop(i) = sum(sum(StrasMatrix));
    
    toc
    fprintf(['iter ', num2str(i), ' done\n'])
end


fq_coop = fq_coop / (N * N);
figure(2)
plot(fq_coop, 'LineWidth', 2)
title('Proportion of cooperators in each iteration')

figure(3)
DrawStraMatrix(StrasMatrix)
title(['StrasMatrix after ', num2str(iter_num), ' iterations'])


