import vibe.d;
import std.stdio;
import std.process;

final class WebChat {
	private Room[string] _rooms;

	// GET /
	void get() {
		render!"index.dt";
	}

	// GET /room?id=...&name=...
	void getRoom(string id, string name) {
		auto messages = getRoom(id).messages;
		render!("room.dt", id, name, messages);
	}

	void postRoom(string id, string name, string message) {
		if (message.length) getRoom(id).addMessage(name, message);
		redirect("room?id="~id.urlEncode~"&name="~name.urlEncode);
	}

	private Room getRoom(string id) {

		static if (__VERSION__ >= 2082) {
			return _rooms.require(id, { return new Room; });
		} else {
			if (id in _rooms) {
				return _rooms[id];
			} else {
				auto r = new Room;
				_rooms[id] = r;
				return r;
			}
		}
	}
}

final class Room {
	string[] messages;

	void addMessage(string name, string message) {
		messages ~= name~": "~message;
	}
}

shared static this() {

	auto PORT = to!ushort(environment.get("PORT", "5000"));

	// the router will match incoming HTTP requests to the proper routes
	auto router = new URLRouter;
	// registers each method of WebChat in the router
	router.registerWebInterface(new WebChat);
	// match incoming requests to files in the public/ folder
	router.get("*", serveStaticFiles("public/"));

	auto settings = new HTTPServerSettings;
	settings.port = PORT;
	// settings.bindAddresses = ["::", "::1", "127.0.0.1", "http://0.0.0.0", "0.0.0.0"];
	// for production installations, the error stack trace option should
	// stay disabled, because it can leak internal address information to
	// an attacker. However, we'll let keep it enabled during development
	// as a convenient debugging facility.
	//settings.options &= ~HTTPServerOption.errorStackTraces;
	listenHTTP(settings, router);
	runApplication();
}

void main() {}