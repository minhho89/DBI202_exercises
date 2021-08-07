function getUsernameAndEmail() {
    return new Promise((resolve) => {
        const xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState === 4) {
                if (this.status === 200) {
                    const json = JSON.parse(this.responseText);
                    resolve("username=" + json[0].username + "&email=" + json[0].email);
                } else {
                    resolve(null);
                }
            }
        };
        xhttp.open('GET', '/api/user/v1/accounts', true);
        xhttp.send();
    });
}

async function trackUser() {
    const usernameAndEmail = await getUsernameAndEmail();
    console.log("ssss " + usernameAndEmail);

    const xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState === 4) {
            if (this.status === 200) {
                // const json = JSON.parse(this.responseText);
                // resolve(json[0].email);
            } else {
                resolve(null);
            }
        }
    };
    xhttp.open('POST', 'https://site.funix.edu.vn/tracking/tracking.php', true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send(usernameAndEmail + "&host=" + window.location.hostname + "&uri=" + window.location.pathname);
}

trackUser();