class Handler():
    def get(self, event, context):
        print event
        return "Hello World"
