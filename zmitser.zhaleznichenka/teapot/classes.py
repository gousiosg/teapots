import math

class model_boundaries:
    def __init__(self, min_x, max_x, min_y, max_y, window_width, window_height):
        self.min_x = min_x
        self.max_x = max_x
        self.min_y = min_y
        self.max_y = max_y
        self.window_width = window_width
        self.window_height = window_height

    def model_width(self):
        return math.fabs(self.max_x - self.min_x)

    def model_height(self):
        return math.fabs(self.max_y - self.min_y)

    def scale_factor(self):
        return min(self.window_width / self.model_width(), self.window_height / self.model_height())

    def segment_center(self, min, max):
        return (max + min) / 2

    def shift_x(self):
        return self.segment_center(self.min_x, self.max_x) * self.scale_factor()

    def shift_y(self):
        return self.segment_center(self.min_y, self.max_y) * self.scale_factor()

class point:
    def __init__(self, x, y):
        self.data = (x, y)

    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    def __str__(self):
        return '(' + str(self.data[0]) + ', ' + str(self.data[1]) + ')'

    def get(self):
        return self.data

    def get_x(self):
        return self.data[0]

    def get_y(self):
        return self.data[1]
