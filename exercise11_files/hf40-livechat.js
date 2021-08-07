/* eslint-disable no-unused-vars */
function getFormHTML() {
	const url = `${ this.host }/hf40-livechat/form.html`;

	return new Promise((resolve) => {
		const xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
			if (this.readyState === 4 && this.status === 200) {
				resolve(this.responseText);
			}
		};
		xhttp.open('GET', url, true);
		xhttp.send();
	});
	// return $.get(url);
}

function getEmail() {
	return new Promise((resolve) => {
		if (this.testMode) {
			const email = prompt('Enter student email', 'anhnd@funix.edu.vn');
			resolve(email && email.length ? email : 'anhnd@funix.edu.vn');
			return;
		}

		const xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
			if (this.readyState === 4) {
				if (this.status === 200) {
					const json = JSON.parse(this.responseText);
					resolve(json[0].email);
				} else {
					resolve(null);
				}
			}
		};
		xhttp.open('GET', '/api/user/v1/accounts', true);
		xhttp.send();
	});
}

function getDepartment() {
	if (this.testMode) {
		return 'Dev test';
	}

	let str = window.location.href;
	str = str.substring(str.lastIndexOf('FUNiX+') + 6);
	str = str.substring(0, str.indexOf('_'));

	return str;
}

function openTab(evt, tabName) {
	const tabcontent = document.getElementsByClassName('mentoring-tabcontent');
	const tablinks = document.getElementsByClassName('mentoring-tablinks');

	for (let i = 0; i < tabcontent.length; i++) {
		tabcontent[i].style.display = 'none';
	}

	for (let i = 0; i < tablinks.length; i++) {
		tablinks[i].className = tablinks[i].className.replace(' active', '');
	}

	// Show the current tab, and add an "active" class to the button that opened the tab
	document.getElementById(tabName).style.display = 'flex';
	evt.currentTarget.className += ' active';
}

async function validateForm() {
	const email = await getEmail();
	console.log(email);
	if (!email) {
		return;
	}
	const department = getDepartment();
	const name = email;

	const hannahDepartment = encodeURIComponent('Hannah');
	const urlBase = `?xTerName=${ name }&xTerEmail=${ email }`;
	const mentorUrl = `${ this.host }/hf40-livechat/pages/livechat.html${ urlBase }&hannah=false&xTerDepartment=${ department }&route=livechat`;
	const hannahUrl = `${ this.host }/hf40-livechat/pages/livechat.html${ urlBase }&hannah=true&xTerDepartment=${ hannahDepartment }&route=livechat`;
	const bookingUrl = `${ this.host }/hf40-livechat/pages/livechat.html${ urlBase }&hannah=false&xTerDepartment=${ department }&route=mentorBooking`;
	const hangingUrl = `${ this.host }/hf40-livechat/pages/livechat.html${ urlBase }&hannah=false&xTerDepartment=${ department }&route=hangingQuestion`;

	const formHTML = await this.getFormHTML();
	$('body').append($(formHTML));
	$('#mentor-container > iframe').attr('src', mentorUrl);
	$('#hanging-question-container > iframe').attr('src', hangingUrl);
	// $('#officer > iframe').attr('src', hannahUrl);
	// $('#booking-container > iframe').attr('src', bookingUrl);

	document.getElementById('tabDefaultOpen').click();
}

async function initHF40(host, testMode) {
	this.host = host;
	this.testMode = testMode;
	this.widget_style = 0;

	// Append form HTML
	console.log('HF40Livechat init');
	validateForm();
}

function showHideWidget() {
	const element = document.getElementById('hflivechat');

	if (this.widget_style === 0) {
		if (element.classList.contains('livechat-widget-minimize')) {
			element.classList.remove('livechat-widget-minimize');
		}

		element.classList.add('livechat-widget-maximize');
		document.getElementById('minimizeBtn').style.display = 'inline-block';
		document.getElementById('maximizeBtn').style.display = 'none';
		this.widget_style = 1;
	} else if (this.widget_style === 1) {
		if (element.classList.contains('livechat-widget-maximize')) {
			element.classList.remove('livechat-widget-maximize');
		}

		element.classList.add('livechat-widget-minimize');
		document.getElementById('minimizeBtn').style.display = 'none';
		document.getElementById('maximizeBtn').style.display = 'inline-block';
		this.widget_style = 0;
	}
}

function showMaximize() {
	const element = document.getElementById('hflivechat');
	if (element.classList.contains('livechat-widget-minimize')) {
		element.classList.remove('livechat-widget-minimize');
	}

	element.classList.add('livechat-widget-maximize');
	document.getElementById('minimizeBtn').style.display = 'inline-block';
	document.getElementById('maximizeBtn').style.display = 'none';
	this.widget_style = 1;
}

function showMinimize() {
	const element = document.getElementById('hflivechat');
	if (element.classList.contains('livechat-widget-maximize')) {
		element.classList.remove('livechat-widget-maximize');
	}

	element.classList.add('livechat-widget-minimize');
	document.getElementById('minimizeBtn').style.display = 'none';
	document.getElementById('maximizeBtn').style.display = 'inline-block';
	this.widget_style = 0;
}
