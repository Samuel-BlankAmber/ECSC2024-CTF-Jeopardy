const express = require('express')
var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('/database/database.sqlite3');
const app = express()
const port = 3000

const tokens = {"db069213e7462a925571f755c94f3a3a": 0, "0aa4c3c1c6bf03b0c9bf9a2a7b3a1431": 1, "d6a4cd22cbe0ed9d73f2a7f30bda65bc": 2, "fc1bff13eead1059dda3b3e48200e085": 3, "91bf0e6eb30c23520ff180545735bf39": 4, "920c7fdc243edd8ba417c72fff2fbc1f": 5, "8f61eb30af25ab091ae1051ce60bff23": 6, "ea8fb7e222c12adb5e449cdda766db39": 7, "572bd88281334a6d0a04ab5ff14900d9": 8, "3c5201f6096e4de6169a9044ca23ab76": 9, "2dac4e56764f0440ae0ab50ea7421579": 10, "fcd954d73183b8b73dec5d2e0afaf573": 11, "2a1822e6a91f9d0f5ee9773715fb9671": 12, "edb5a59fa2f85dcde3531823f733a1cc": 13, "1e98a1a5c4f68522101848a05fa206f6": 14, "60a9cdbc4ee34b50e1f56f0942ed13f3": 15, "5ad768d610271b48769525db3e638970": 16, "e6c4f009f7806059628da6c49a8f9358": 17, "c5508552612bac2c521b0ebe11205368": 18, "79b1f858820e4bf617f472793b8d5c74": 19, "4a80e0740b1011863183f8acc2a08533": 20, "8933f9a5b0bde40673fafe5e728cddce": 21, "1d725ebbf1bb9bddce67e91ea7893e11": 22, "653a243527e455f3a9903f907979ab1d": 23, "e2f86c258392f9bab71bca33e04368e9": 24, "da12cc3c71ac12f697476a36027be759": 25, "3f80de00a75d87c565bd83fdd9703389": 26, "cc52fd2bcc7580cbecdd066eb1c89d15": 27, "1ece88dbec751013c948fadd675facf5": 28, "2744cd7c41a02de54b6bbe2834de1fe0": 29, "949c7567ef5ee1e51597a857093e9118": 30, "3e96d1d65ac280e30ddddd242e832a70": 31, "d675260006a4acfe0386ee469418827d": 32, "5f432e066a6483f544213ed05a4ce67e": 33, "726437348e4d9b0fb3d0f3a58cd60138": 34, "8fb16fc761d3d097f1b6a425245aad4d": 35, "55a9fdc616d92c88d03af01ec3a7c0c6": 36, "5b9687879028f594fa573b0c8f21d8a1": 37}

get_all_data = () => {
    return new Promise((resolve, reject) => {         

        let sql = `SELECT * FROM teams_status`;  
        let params = [];

        return db.all(sql, params, function (err, res) {
            if (err) {
                return reject(0);
            }
            return resolve(res);
        });
    });
}

store_data = (id, status) => {
    return new Promise((resolve, reject) => {         

        let sql = `UPDATE teams_status SET status=? WHERE id=?`;  
        let params = [status, id];

        return db.run(sql, params, function (err, res) {
            if (err) {
                return reject(-1);
            }
            return resolve(0);
        });
    });
}

init_database = () => {
    db.serialize(() => {
        db.run("CREATE TABLE IF NOT EXISTS teams_status (id INTEGER, status INTEGER, UNIQUE(id))");
        for (let i = 0; i <= 37; i++) {
            db.run(`INSERT OR IGNORE INTO teams_status (id, status) VALUES (${i}, 0)`);
        }
    })
}

init_database();

app.get("/status", async (req, res) => {
    try {
        const data=await get_all_data();
        res.status(200);
        res.json(data);
        res.end()
    } catch (error) {
        res.status(500)
    }
    
})

app.put('/update/:team_token/:status', async (req, res) => {
    
    try {
        const token = req.params.team_token;
        const status = req.params.status;
        if(!Object.keys(tokens).includes(token) || !["0","1"].includes(status)){
            res.status(404);
            res.send();
            res.end();
        }else{
            const team_id = tokens[token];
            await store_data(team_id, parseInt(status));
            res.status(200);
            res.send();
            res.end()
        }
    } catch (error) {
        res.status(500)
    }
})

app.use(express.static('public'))

app.listen(port, () => {
    console.log(`App listening on port ${port}`)
})