import bpy

class ApplyWithShapeKeys(bpy.types.Operator):
    """Tooltip"""
    bl_idname = "object.applywithshapekeys"
    bl_label = "Apply Modifiers With Shapekeys"

    def execute(self, context):

        selection = bpy.context.selected_objects

        for obj in selection:
            if obj.type == "MESH":

                # lists store temporary objects created from shapekeys
                shapeInstances = []
                shapeValues = []

                # Deactivate any armature modifiers
                for mod in obj.modifiers:
                    if mod.type == 'ARMATURE':
                        obj.modifiers[mod.name].show_viewport = False

                for shape_key in obj.data.shape_keys.key_blocks:
                    # save old shapekey value to restore later. Will set to 0 temporarily
                    shapeValues.append(shape_key.value)
                    shape_key.value = 0.0

                i = 0
                for shape_key in obj.data.shape_keys.key_blocks:

                    # ignore basis shapekey
                    if i != 0:
                        # make sure only relevant object is selected and active
                        bpy.ops.Object.select_all(action="DESELECT")
                        obj.select_set(state=True)
                        context.view_layer.objects.active = obj

                        # make sure only this shape key is set to 1
                        shape_key.value = 1.0

                        # duplicate object with only one shape key active. Blender does the rest
                        bpy.ops.Object.duplicate(linked=False, mode="TRANSLATION")
                        bpy.ops.Object.convert(target="MESH")
                        shapeInstances.append(bpy.context.active_object)

                        bpy.context.object.name = shape_key.name

                        bpy.ops.Object.select_all(action="DESELECT")
                        obj.select_set(state=True)
                        context.view_layer.objects.active = obj

                        shape_key.value = 0.0

                    i = i + 1

                context.view_layer.objects.active = obj

                # create final object
                bpy.ops.Object.duplicate(linked=False, mode="TRANSLATION")
                newobj = bpy.context.active_object
                newobj.name = obj.name + "_APPLIED"

                # clear all old shapekeys from new object
                newobj.shape_key_clear()

                # apply all modifiers on new object
                for mod in newobj.modifiers:
                    if mod.name != "Armature":
                        bpy.ops.object.modifier_apply(apply_as='DATA', modifier=mod.name)

                # iterate all temporary saved shapekey objects, select only that and the final object and join them
                for shapeInstance in shapeInstances:
                    bpy.ops.object.select_all(action="DESELECT")
                    newobj.select_set(state=True)
                    shapeInstance.select_set(state=True)
                    context.view_layer.objects.active = newobj

                    result = bpy.ops.object.join_shapes()

                # reset old shape key values
                i = 0
                for shape_key in newobj.data.shape_keys.key_blocks:
                    if i != 0:
                        shape_key.value = shapeValues[i]
                    i = i + 1

               # reset old shape key values
                i = 0
                for shape_key in obj.data.shape_keys.key_blocks:
                    if i != 0:
                        shape_key.value = shapeValues[i]
                    i = i + 1

                # delete temporary objects    
                bpy.ops.Object.select_all(action="DESELECT")
                for shapeInstance in shapeInstances:
                    shapeInstance.select_set(state=True)

                bpy.ops.object.delete(use_global=False)

                # redeactivate armature modifiers
                for mod in obj.modifiers:
                    if mod.type == 'ARMATURE':
                        obj.modifiers[mod.name].show_viewport = True

                for mod in newobj.modifiers:
                    if mod.type == 'ARMATURE':
                        newobj.modifiers[mod.name].show_viewport = True

        return {"FINISHED"}

def register():
    bpy.utils.register_class(ApplyWithShapeKeys)

def unregister():
    bpy.utils.unregister_class(ApplyWithShapeKeys)

if __name__ == "__main__":
    register()