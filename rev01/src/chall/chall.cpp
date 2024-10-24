#include <bits/stdc++.h>
#define cond_type tuple<bool, int, bool, int>
#define CHUNKS 200

using namespace std;

const string alph = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-";

vector<int> gen_primes(int ub){
    vector<int> lp(ub+1);
    vector<int> res;

    for(int i = 2; i <= ub; i++){
        if(!lp[i]){
            lp[i] = i;
            res.push_back(i);
        }
        for(int j = 0; i*res[j] <= ub; j++){
            lp[i*res[j]] = res[j];
            if(res[j] == lp[i]) break;
        }
    }

    return res;
}

void forward_dfs(int v, vector<bool>& visited, vector<vector<int>>& adj, vector<int>& top_order){
    if (visited[v]) return;
    visited[v] = true;
    for(auto u : adj[v])
        forward_dfs(u, visited, adj, top_order);
    top_order.push_back(v);
}

void backward_dfs(int v, int c, vector<int>& components, vector<vector<int>>& inv_adj){
    if (components[v] != -1) return;
    components[v] = c;
    for(auto u : inv_adj[v])
        backward_dfs(u, c, components, inv_adj);
}

bool evaluate_expr(int n, set<cond_type>& conditions){
    bool is_sat = true;
    vector<vector<int>> adj(2*n), inv_adj(2*n), adj_components(2*n);
    vector<bool> visited(2*n, false), forall(2*n, false), exists(2*n, false);
    vector<int> components(2*n, -1), top_order;

    for(auto el : conditions){
        auto x = get<0>(el);
        auto a = get<1>(el);
        auto y = get<2>(el);
        auto b = get<3>(el);

        adj[2*a+!x].push_back(2*b+y);
        adj[2*b+!y].push_back(2*a+x);
        inv_adj[2*b+y].push_back(2*a+!x);
        inv_adj[2*a+x].push_back(2*b+!y);
    }

    for(int i = 0; i < 2*n; i++)
        forward_dfs(i, visited, adj, top_order);

    reverse(top_order.begin(), top_order.end());

    for(int i = 0; i < 2*n; i++)
        backward_dfs(top_order[i], i, components, inv_adj);

    for(int i = 0; i < n; i++)
        if(components[2*i] == components[2*i+1]) is_sat = false;
    
    for(int i = 0; i < 2*n; i++){
        for(auto u : adj[i])
            adj_components[components[i]].push_back(components[u]);
        if(forall[components[i]]) is_sat = false;
        forall[components[i]] = true;
    }

    for(int i = 2*n-1; i >= 0; i--){
        auto tmp = forall[i];
        for(auto u : adj_components[i]){
            if(forall[u] && tmp && u != i) is_sat = false;
            if(forall[u]) forall[i] = true;
        }
    }

    return is_sat;
}

bool sanity_checks(string key){
    if(key.length() != CHUNKS * 5 - 1)
        return false;

    for(auto c : key){
        if(alph.find(c) == string::npos)
            return false;
    }
    return true;
}

bool check(string key){
    vector<array<int,2>> seq;
    set<cond_type> conditions;
    vector<int> quantifiers;
    bool res = true;

    if(!sanity_checks(key))
        return false;

    for (int i = -1; i < int(key.length()); i+=5){
        if (i >= 0 && key[i] != '-')
            return false;
        
        int tmp = 0, acc = 1;
        auto chunk = key.substr(i+1, 4);

        for(int j = 0; j < 4; j++){
            tmp += acc * int(alph.find(chunk[j]));
            acc *= int(alph.length())-1;
        }
        seq.push_back({tmp, tmp ^ 0xffffff});
    }

    set<array<int, 2>> unique(seq.begin(), seq.end());
    
    if(unique.size() != seq.size()) res &= false;

    vector<int> primes = gen_primes(1 << 24);

    for(auto p : primes){
        if(p != 2){
            vector<int> both;
            vector<array<int, 2>> one;

            for(int j = 0; j < int(seq.size()); j++){
                if(seq[j][0]%p == 0 && seq[j][1]%p == 0) both.push_back(j);
                else if(seq[j][0]%p == 0) one.push_back({j, 0});
                else if(seq[j][1]%p == 0) one.push_back({j, 1});
            }

            int bs = int(both.size());
            int os = int(one.size());

            if(bs >= 2){
                res &= false;
            }
            if(bs == 1){
                for(auto el : one){
                    conditions.insert(make_tuple(el[0], el[1] ^ 1, el[0], el[1] ^ 1));
                }
            }
            else{
                for(int i = 0; i < os-1; i++){
                    for(int j = i + 1; j < os; j++){
                        conditions.insert(make_tuple(one[i][0], one[i][1] ^ 1, one[j][0], one[j][1] ^ 1));
                    }
                }
            }
        }
    }
    res &= evaluate_expr(seq.size(), conditions);
    return res;
}

int main(){
    cin.tie(0)->sync_with_stdio(0);
    string key;

    cout << "Key: " << flush;
    cin >> key;

    if(check(key)){
        string flag;
        ifstream flagfile("/home/user/flag");
        cout << "Correct!" << endl;
        if(flagfile.is_open()){
            getline(flagfile, flag);
            cout << flag << endl;
            flagfile.close();
        }
        else cout << "Flag not found on the server, please contact an admin." << endl;
        
    }
    else cout << "Wrong!" << endl;
    return 0;
}