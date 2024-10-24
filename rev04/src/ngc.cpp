#include "bits/stdc++.h"
using namespace std;


// #define DEBUG


#define MAXTICKS 350
#define TARGET 1000


struct Res {
    int iron;
    int copper;
    int coal;
    int tin;
    int coal_coke;
    int steel;
    int iron_ingot;
    int copper_ingot;
    int tin_ingot;
    int iron_rod;
    int copper_sheet;
    int copper_pipe;
    int bronze;
    int screw;
    int alloy;
    int xxx;

    bool operator<=(const Res& other) const {
        return (
            (iron <= other.iron) &&
            (copper <= other.copper) &&
            (coal <= other.coal) &&
            (tin <= other.tin) &&
            (coal_coke <= other.coal_coke) &&
            (steel <= other.steel) &&
            (iron_ingot <= other.iron_ingot) &&
            (copper_ingot <= other.copper_ingot) &&
            (tin_ingot <= other.tin_ingot) &&
            (iron_rod <= other.iron_rod) &&
            (copper_sheet <= other.copper_sheet) &&
            (copper_pipe <= other.copper_pipe) &&
            (bronze <= other.bronze) &&
            (screw <= other.screw) &&
            (alloy <= other.alloy) &&
            (xxx <= other.xxx) );
    };
    Res operator+(const Res& other) const {
        return Res({
            iron + other.iron,
            copper + other.copper,
            coal + other.coal,
            tin + other.tin,
            coal_coke + other.coal_coke,
            steel + other.steel,
            iron_ingot + other.iron_ingot,
            copper_ingot + other.copper_ingot,
            tin_ingot + other.tin_ingot,
            iron_rod + other.iron_rod,
            copper_sheet + other.copper_sheet,
            copper_pipe + other.copper_pipe,
            bronze + other.bronze,
            screw + other.screw,
            alloy + other.alloy,
            xxx + other.xxx,
        });
    };
    Res operator-(const Res& other) const {
        return Res({
            iron - other.iron,
            copper - other.copper,
            coal - other.coal,
            tin - other.tin,
            coal_coke - other.coal_coke,
            steel - other.steel,
            iron_ingot - other.iron_ingot,
            copper_ingot - other.copper_ingot,
            tin_ingot - other.tin_ingot,
            iron_rod - other.iron_rod,
            copper_sheet - other.copper_sheet,
            copper_pipe - other.copper_pipe,
            bronze - other.bronze,
            screw - other.screw,
            alloy - other.alloy,
            xxx - other.xxx,
        });
    };
};


struct Mach {
    int id;
    int level;
    struct Res price;
    struct Res cons;
    struct Res prod;
    struct Res storage;
    vector<int> ins;
    vector<int> outs;
};


Mach iron_miner({
    .id = 0,
    .level = 0,
    .price = {
        .iron = 100,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {0},
    .prod = {
        .iron = 25,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach copper_miner({
    .id = 1,
    .level = 0,
    .price = {
        .iron = 250,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {0},
    .prod = {
        .iron = 0,
        .copper = 25,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach coal_miner({
    .id = 2,
    .level = 0,
    .price = {
        .iron = 200,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {0},
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 25,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach tin_miner({
    .id = 3,
    .level = 0,
    .price = {
        .iron = 250,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {0},
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 25,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach coke_oven({
    .id = 4,
    .level = -1,
    .price = {
        .iron = 250,
        .copper = 50,
        .coal = 250,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 25,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 20,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach blast_furnace({
    .id = 5,
    .level = -1,
    .price = {
        .iron = 500,
        .copper = 0,
        .coal = 500,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 50,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 50,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 50,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach iron_smelter({
    .id = 6,
    .level = -1,
    .price = {
        .iron = 300,
        .copper = 0,
        .coal = 100,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 25,
        .copper = 0,
        .coal = 25,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 25,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach copper_smelter({
    .id = 7,
    .level = -1,
    .price = {
        .iron = 300,
        .copper = 0,
        .coal = 100,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 25,
        .coal = 25,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 25,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach tin_smelter({
    .id = 8,
    .level = -1,
    .price = {
        .iron = 300,
        .copper = 0,
        .coal = 100,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 25,
        .tin = 25,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 25,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach extruder({
    .id = 9,
    .level = -1,
    .price = {
        .iron = 200,
        .copper = 200,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 200,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 50,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 50,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach copper_press({
    .id = 10,
    .level = -1,
    .price = {
        .iron = 200,
        .copper = 200,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 100,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 50,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 50,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach copper_soldering({
    .id = 11,
    .level = -1,
    .price = {
        .iron = 200,
        .copper = 200,
        .coal = 100,
        .tin = 0,
        .coal_coke = 0,
        .steel = 100,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 50,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 50,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 50,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach bronze_smelter({
    .id = 12,
    .level = -1,
    .price = {
        .iron = 0,
        .copper = 0,
        .coal = 200,
        .tin = 0,
        .coal_coke = 0,
        .steel = 300,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 200,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 100,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 50,
        .tin_ingot = 50,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 50,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach screw_maker({
    .id = 13,
    .level = -1,
    .price = {
        .iron = 400,
        .copper = 0,
        .coal = 400,
        .tin = 0,
        .coal_coke = 0,
        .steel = 400,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 100,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 50,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 100,
        .alloy = 0,
        .xxx = 0,
    },
    .storage = {0},
});

Mach foundry({
    .id = 14,
    .level = -1,
    .price = {
        .iron = 400,
        .copper = 200,
        .coal = 400,
        .tin = 0,
        .coal_coke = 0,
        .steel = 400,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 100,
        .copper_sheet = 0,
        .copper_pipe = 100,
        .bronze = 100,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 100,
        .copper_ingot = 100,
        .tin_ingot = 100,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 100,
        .xxx = 0,
    },
    .storage = {0},
});

Mach assembler({
    .id = 15,
    .level = -1,
    .price = {
        .iron = 1000,
        .copper = 500,
        .coal = 100,
        .tin = 0,
        .coal_coke = 0,
        .steel = 500,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 200,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 250,
        .xxx = 0,
    },
    .cons = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 50,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 100,
        .alloy = 100,
        .xxx = 0,
    },
    .prod = {
        .iron = 0,
        .copper = 0,
        .coal = 0,
        .tin = 0,
        .coal_coke = 0,
        .steel = 0,
        .iron_ingot = 0,
        .copper_ingot = 0,
        .tin_ingot = 0,
        .iron_rod = 0,
        .copper_sheet = 0,
        .copper_pipe = 0,
        .bronze = 0,
        .screw = 0,
        .alloy = 0,
        .xxx = 20,
    },
    .storage = {0},
});



Res curr_res({
    .iron = 100,
    .copper = 0,
    .coal = 0,
    .tin = 0,
    .coal_coke = 0,
    .steel = 0,
    .iron_ingot = 0,
    .copper_ingot = 0,
    .tin_ingot = 0,
    .iron_rod = 0,
    .copper_sheet = 0,
    .copper_pipe = 0,
    .bronze = 0,
    .screw = 0,
    .alloy = 0,
    .xxx = 0,
});

vector<Mach> curr_machs;

#ifdef DEBUG
void print_res(string name, int id, Res r){
    if(!(r <= Res({0}))){
        cerr << name << " " << id;
        if(r.iron > 0) cerr << "\n\tiron: " << r.iron;
        if(r.copper > 0) cerr << "\n\tcopper: " << r.copper;
        if(r.coal > 0) cerr << "\n\tcoal: " << r.coal;
        if(r.tin > 0) cerr << "\n\ttin: " << r.tin;
        if(r.coal_coke > 0) cerr << "\n\tcoal_coke: " << r.coal_coke;
        if(r.steel > 0) cerr << "\n\tsteel: " << r.steel;
        if(r.iron_ingot > 0) cerr << "\n\tiron_ingot: " << r.iron_ingot;
        if(r.copper_ingot > 0) cerr << "\n\tcopper_ingot: " << r.copper_ingot;
        if(r.tin_ingot > 0) cerr << "\n\ttin_ingot: " << r.tin_ingot;
        if(r.iron_rod > 0) cerr << "\n\tiron_rod: " << r.iron_rod;
        if(r.copper_sheet > 0) cerr << "\n\tcopper_sheet: " << r.copper_sheet;
        if(r.copper_pipe > 0) cerr << "\n\tcopper_pipe: " << r.copper_pipe;
        if(r.bronze > 0) cerr << "\n\tbronze: " << r.bronze;
        if(r.screw > 0) cerr << "\n\tscrew: " << r.screw;
        if(r.alloy > 0) cerr << "\n\talloy: " << r.alloy;
        if(r.xxx > 0) cerr << "\n\txxx: " << r.xxx;
        cerr << endl << endl;
    }
}
#endif

void die(string m){
    cout << m << endl;
    exit(EXIT_FAILURE);
}

void take(int m_id){
    curr_res = curr_res + curr_machs[m_id].storage;
    curr_machs[m_id].storage = curr_machs[m_id].storage - curr_machs[m_id].storage;
}

void input(){
    #ifdef DEBUG
    cerr << "input" << endl;
    #endif
    string s;
    int m_id, m_id2;
    cin >> s;
    #ifdef DEBUG
    cerr << s << endl;
    #endif
    if(s[0] == 'B'){ // Build
        if(s.size() != 3){
            die("Invalid move");
        }
        m_id = (s[1]-'A')*26 + (s[2]-'A');
        Mach m;
        bool enough = false;
        switch(m_id){
            case 0:
                if(iron_miner.price <= curr_res){
                    enough = true;
                    curr_res = curr_res - iron_miner.price;
                    memcpy(&m, &iron_miner, sizeof(Mach));
                }
                break;
            case 1:
                if(copper_miner.price <= curr_res){
                    curr_res = curr_res - copper_miner.price;
                    enough = true;
                    memcpy(&m, &copper_miner, sizeof(Mach));
                }
                break;
            case 2:
                if(coal_miner.price <= curr_res){
                    curr_res = curr_res - coal_miner.price;
                    enough = true;
                    memcpy(&m, &coal_miner, sizeof(Mach));
                }
                break;
            case 3:
                if(tin_miner.price <= curr_res){
                    curr_res = curr_res - tin_miner.price;
                    enough = true;
                    memcpy(&m, &tin_miner, sizeof(Mach));
                }
                break;
            case 4:
                if(coke_oven.price <= curr_res){
                    curr_res = curr_res - coke_oven.price;
                    enough = true;
                    memcpy(&m, &coke_oven, sizeof(Mach));
                }
                break;
            case 5:
                if(blast_furnace.price <= curr_res){
                    curr_res = curr_res - blast_furnace.price;
                    enough = true;
                    memcpy(&m, &blast_furnace, sizeof(Mach));
                }
                break;
            case 6:
                if(iron_smelter.price <= curr_res){
                    curr_res = curr_res - iron_smelter.price;
                    enough = true;
                    memcpy(&m, &iron_smelter, sizeof(Mach));
                }
                break;
            case 7:
                if(copper_smelter.price <= curr_res){
                    curr_res = curr_res - copper_smelter.price;
                    enough = true;
                    memcpy(&m, &copper_smelter, sizeof(Mach));
                }
                break;
            case 8:
                if(tin_smelter.price <= curr_res){
                    curr_res = curr_res - tin_smelter.price;
                    enough = true;
                    memcpy(&m, &tin_smelter, sizeof(Mach));
                }
                break;
            case 9:
                if(extruder.price <= curr_res){
                    curr_res = curr_res - extruder.price;
                    enough = true;
                    memcpy(&m, &extruder, sizeof(Mach));
                }
                break;
            case 10:
                if(copper_press.price <= curr_res){
                    curr_res = curr_res - copper_press.price;
                    enough = true;
                    memcpy(&m, &copper_press, sizeof(Mach));
                }
                break;
            case 11:
                if(copper_soldering.price <= curr_res){
                    curr_res = curr_res - copper_soldering.price;
                    enough = true;
                    memcpy(&m, &copper_soldering, sizeof(Mach));
                }
                break;
            case 12:
                if(bronze_smelter.price <= curr_res){
                    curr_res = curr_res - bronze_smelter.price;
                    enough = true;
                    memcpy(&m, &bronze_smelter, sizeof(Mach));
                }
                break;
            case 13:
                if(screw_maker.price <= curr_res){
                    curr_res = curr_res - screw_maker.price;
                    enough = true;
                    memcpy(&m, &screw_maker, sizeof(Mach));
                }
                break;
            case 14:
                if(foundry.price <= curr_res){
                    curr_res = curr_res - foundry.price;
                    enough = true;
                    memcpy(&m, &foundry, sizeof(Mach));
                }
                break;
            case 15:
                if(assembler.price <= curr_res){
                    curr_res = curr_res - assembler.price;
                    enough = true;
                    memcpy(&m, &assembler, sizeof(Mach));
                }
                break;
            default:
                die("Invalid move");
        }
        if(enough){
            m.ins = vector<int>();
            m.outs = vector<int>();
            curr_machs.push_back(m);
            #ifdef DEBUG
            cerr << "id: " << curr_machs.size()-1 << endl;
            #endif
        }
        else{
            die("Invalid move");
        }
    }
    else if(s[0] == 'C'){ // Connect
        if(s.size() != 5){
            die("Invalid move");
        }
        m_id = (s[1]-'A')*26 + (s[2]-'A');
        if(curr_machs.size() <= m_id){
            die("Invalid move");
        }
        m_id2 = (s[3]-'A')*26 + (s[4]-'A');
        if(curr_machs.size() <= m_id2){
            die("Invalid move");
        }

        if((curr_machs[m_id].level == -1) || ((curr_machs[m_id2].level != -1) && (curr_machs[m_id].level >= curr_machs[m_id2].level) ) ){
            die("invalid move");
        }

        curr_machs[m_id].outs.push_back(m_id2);
        curr_machs[m_id2].ins.push_back(m_id);

        if(curr_machs[m_id].level >= curr_machs[m_id2].level){
            curr_machs[m_id2].level = curr_machs[m_id].level + 1;
        }

    }
    else if(s[0] == 'T'){ // Take
        if(s.size() != 3){
            die("Invalid move");
        }
        m_id = (s[1]-'A')*26 + (s[2]-'A');
        if(curr_machs.size() <= m_id){
            die("Invalid move");
        }
        take(m_id);
    }
    else if(s[0] == 'W'){ // Wait
        if(s.size() != 1){
            die("Invalid move");
        }
    }
    else if(s[0] == 'Q'){ // Quit
        die("Bye");
    }
    else {
        die("Invalid move");
    }
}



void tick(){
    for(int l=0; l<curr_machs.size(); l++){
        for(int i=0; i<curr_machs.size(); i++){
            if(curr_machs[i].level == l){
                Res temp_res = {0};
                for(int iid: curr_machs[i].ins){
                    temp_res = temp_res + curr_machs[iid].storage;
                }
                #ifdef DEBUG
                // print_res("temp pre", i, temp_res);
                #endif
                if(curr_machs[i].cons <= temp_res + curr_machs[i].storage){
                    temp_res = curr_machs[i].cons - curr_machs[i].storage;
                    #ifdef DEBUG
                    // print_res("temp mid", i, temp_res);
                    // print_res("cons", i, curr_machs[i].cons);
                    // print_res("stor", i, curr_machs[i].storage);
                    #endif
                    for(int iid: curr_machs[i].ins){
                        if(temp_res.iron > 0 && curr_machs[iid].storage.iron > 0){
                            int qty = min(temp_res.iron, curr_machs[iid].storage.iron);
                            curr_machs[iid].storage.iron -= qty;
                            temp_res.iron -= qty;
                            curr_machs[i].storage.iron += qty;
                        }
                        if(temp_res.copper > 0 && curr_machs[iid].storage.copper > 0){
                            int qty = min(temp_res.copper, curr_machs[iid].storage.copper);
                            curr_machs[iid].storage.copper -= qty;
                            temp_res.copper -= qty;
                            curr_machs[i].storage.copper += qty;
                        }
                        if(temp_res.coal > 0 && curr_machs[iid].storage.coal > 0){
                            int qty = min(temp_res.coal, curr_machs[iid].storage.coal);
                            curr_machs[iid].storage.coal -= qty;
                            temp_res.coal -= qty;
                            curr_machs[i].storage.coal += qty;
                        }
                        if(temp_res.tin > 0 && curr_machs[iid].storage.tin > 0){
                            int qty = min(temp_res.tin, curr_machs[iid].storage.tin);
                            curr_machs[iid].storage.tin -= qty;
                            temp_res.tin -= qty;
                            curr_machs[i].storage.tin += qty;
                        }
                        if(temp_res.coal_coke > 0 && curr_machs[iid].storage.coal_coke > 0){
                            int qty = min(temp_res.coal_coke, curr_machs[iid].storage.coal_coke);
                            curr_machs[iid].storage.coal_coke -= qty;
                            temp_res.coal_coke -= qty;
                            curr_machs[i].storage.coal_coke += qty;
                        }
                        if(temp_res.steel > 0 && curr_machs[iid].storage.steel > 0){
                            int qty = min(temp_res.steel, curr_machs[iid].storage.steel);
                            curr_machs[iid].storage.steel -= qty;
                            temp_res.steel -= qty;
                            curr_machs[i].storage.steel += qty;
                        }
                        if(temp_res.iron_ingot > 0 && curr_machs[iid].storage.iron_ingot > 0){
                            int qty = min(temp_res.iron_ingot, curr_machs[iid].storage.iron_ingot);
                            curr_machs[iid].storage.iron_ingot -= qty;
                            temp_res.iron_ingot -= qty;
                            curr_machs[i].storage.iron_ingot += qty;
                        }
                        if(temp_res.copper_ingot > 0 && curr_machs[iid].storage.copper_ingot > 0){
                            int qty = min(temp_res.copper_ingot, curr_machs[iid].storage.copper_ingot);
                            curr_machs[iid].storage.copper_ingot -= qty;
                            temp_res.copper_ingot -= qty;
                            curr_machs[i].storage.copper_ingot += qty;
                        }
                        if(temp_res.tin_ingot > 0 && curr_machs[iid].storage.tin_ingot > 0){
                            int qty = min(temp_res.tin_ingot, curr_machs[iid].storage.tin_ingot);
                            curr_machs[iid].storage.tin_ingot -= qty;
                            temp_res.tin_ingot -= qty;
                            curr_machs[i].storage.tin_ingot += qty;
                        }
                        if(temp_res.iron_rod > 0 && curr_machs[iid].storage.iron_rod > 0){
                            int qty = min(temp_res.iron_rod, curr_machs[iid].storage.iron_rod);
                            curr_machs[iid].storage.iron_rod -= qty;
                            temp_res.iron_rod -= qty;
                            curr_machs[i].storage.iron_rod += qty;
                        }
                        if(temp_res.copper_sheet > 0 && curr_machs[iid].storage.copper_sheet > 0){
                            int qty = min(temp_res.copper_sheet, curr_machs[iid].storage.copper_sheet);
                            curr_machs[iid].storage.copper_sheet -= qty;
                            temp_res.copper_sheet -= qty;
                            curr_machs[i].storage.copper_sheet += qty;
                        }
                        if(temp_res.copper_pipe > 0 && curr_machs[iid].storage.copper_pipe > 0){
                            int qty = min(temp_res.copper_pipe, curr_machs[iid].storage.copper_pipe);
                            curr_machs[iid].storage.copper_pipe -= qty;
                            temp_res.copper_pipe -= qty;
                            curr_machs[i].storage.copper_pipe += qty;
                        }
                        if(temp_res.bronze > 0 && curr_machs[iid].storage.bronze > 0){
                            int qty = min(temp_res.bronze, curr_machs[iid].storage.bronze);
                            curr_machs[iid].storage.bronze -= qty;
                            temp_res.bronze -= qty;
                            curr_machs[i].storage.bronze += qty;
                        }
                        if(temp_res.screw > 0 && curr_machs[iid].storage.screw > 0){
                            int qty = min(temp_res.screw, curr_machs[iid].storage.screw);
                            curr_machs[iid].storage.screw -= qty;
                            temp_res.screw -= qty;
                            curr_machs[i].storage.screw += qty;
                        }
                        if(temp_res.alloy > 0 && curr_machs[iid].storage.alloy > 0){
                            int qty = min(temp_res.alloy, curr_machs[iid].storage.alloy);
                            curr_machs[iid].storage.alloy -= qty;
                            temp_res.alloy -= qty;
                            curr_machs[i].storage.alloy += qty;
                        }
                        if(temp_res.xxx > 0 && curr_machs[iid].storage.xxx > 0){
                            int qty = min(temp_res.xxx, curr_machs[iid].storage.xxx);
                            curr_machs[iid].storage.xxx -= qty;
                            temp_res.xxx -= qty;
                            curr_machs[i].storage.xxx += qty;
                        }
                    }
                    #ifdef DEBUG
                    // print_res("temp_res", 0, temp_res);
                    #endif
                    curr_machs[i].storage = curr_machs[i].storage - curr_machs[i].cons;
                    curr_machs[i].storage = curr_machs[i].storage + curr_machs[i].prod;
                }
            }
        }
    }
}


void print_flag(){
    cout << getenv("FLAG") << endl;
}


int main(){

    cout << "What's your solution?" << endl;

    for(int i=0; i<MAXTICKS; i++){
        #ifdef DEBUG
        cerr << i << "-------------------------------------------" << endl;
        #endif

        input();
        tick();
        #ifdef DEBUG
        int cnt=0;
        for(Mach m: curr_machs){
            print_res("m", cnt++, m.storage);
        }
        print_res("Inventory", 0, curr_res);
        #endif

        if(curr_res.xxx >= TARGET){
            print_flag();
            exit(EXIT_SUCCESS);
        }
    }

}